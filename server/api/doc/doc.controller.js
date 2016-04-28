'use strict';

var  doc = require('./doc.model'),
response = require("../response"),
 request = require('request'),
    path = require("path"),
       _ = require('lodash');

// Default cache duration
var CACHE_DURATION = 24*60*60*1000;

exports.create = function(req, res) {
  var rent = _.clone(req.body);
  // Save user ip to avoid flooding
  rent.ip_hash = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  // Save the rent
  doc.save(rent).then(function(rent) {
      res.json(rent);
    // Handles errors
  }, response.handleError(res, 500)).fail(response.handleError(res, 500));
};

exports.allPng = function(req, res) {
  res.sendFile( path.resolve( __dirname, "../../cache/all.png") );
};


var reqCenter = function(req) {
  // Extract coordinates from query
  return _( req.query.latlng.split(',') )
    // Remove whitespaces
    .map(_.trim)
    // Cast to number
    .map(Number)
    // Return values
    .value()
}

exports.centerPng = function(req, res) {
  // Check parameters
  if(!req.query.latlng) {
    return response.validationError(res)({ error: "'latlng' parameter must not be empty."});
  } else if( req.query.latlng.split(',').length !== 2 ) {
    return response.validationError(res)({ error: "'latlng' parameter is malformed."});
  }

  var center = reqCenter(req);
  // Center must not be welformed
  if( isNaN(center[0]) || isNaN(center[1])  ) {
    return response.validationError(res)({ error: "'latlng' parameter is malformed."});
  }
  // Distance in km
  center[2] = 3;
  // Get center according to the request
  doc.center.apply(null, center).then(function(rows) {
    try {
      // Drawing points...
      var canvas = require('../../canvas/doc').scatterplot(rows, 480*2, 480*2, "#FFF");
    // Something may happen
    } catch(e) {
      return response.validationError(res)({ error: "Unbale to generate"});
    }

    var image = canvas.toBuffer();
    // Cache the result
    response.setCachedRequest(req, image, CACHE_DURATION);

    res.type('image/png');
    res.end(image, 'binary');
  }, response.handleError(res, 500)).fail(response.handleError(res, 500));
};


exports.centerJson = function(req, res) {
  // Check parameters
  if(!req.query.latlng) {
    return response.validationError(res)({ error: "'latlng' parameter must not be empty."});
  } else if( req.query.latlng.split(',').length !== 2 ) {
    return response.validationError(res)({ error: "'latlng' parameter is malformed."});
  }

  var center = reqCenter(req);
  // Center must not be welformed
  if( isNaN(center[0]) || isNaN(center[1])  ) {
    return response.validationError(res)({ error: "'latlng' parameter is malformed."});
  }

  var url = "http://api.rentswatch.com/api/cities/geocode";
  // Build geocoder params
  var params = {
    token: process.env.RENTSWATCH_API_TOKEN,
    // Rejoin params to avoid mistakes
    q: center.join(','),
    radius: 2,
    limit: 5000
  };
  // Geocode the query
  request({ url: url, json: true, qs: params }, function(err, resp, body) {
    res.json({
      total: body.total || 0,
      avgPricePerSqm: body.avgPricePerSqm
    });
  });
};
