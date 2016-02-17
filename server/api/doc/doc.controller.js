'use strict';

var  doc = require('./doc.model'),
response = require("../response"),
    path = require("path"),
       _ = require('lodash');

// Default cache duration
var CACHE_DURATION = 24*60*60*1000;

exports.allPng = function(req, res) {
  res.sendFile( path.resolve( __dirname, "../../cache/all.png") );
};


exports.allJson  = function(req, res) {
  res.json( require("../../cache/all.json") );
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

  // Get center according to the request
  doc.center.apply(null, center).then(function(rows) {
    try {
      // Drawing points...
      var canvas = require('../../canvas/doc').scatterplot(rows, 480*2, 480*2, "#F2B100");
    // Something may happen
    } catch(e) {
      return response.validationError(res)({ error: "Unbale to generate"});
    }

    var image = canvas.toBuffer();
    // Cache the result
    response.setCachedRequest(req, image, CACHE_DURATION);

    res.type('image/png');
    res.end(image, 'binary');
  });
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

  // Get center according to the request
  // doc.centeredDecades.apply(null, center(req) ).then(function(decades) { });
  var decades = []
  var stats = { decades: decades };
  // Extracting slope...
  doc.losRegression.apply(null, center).then(function(slope) {
    stats.slope = slope;
    // Timestamp of the last snapshot
    stats.lastSnapshot =  ~~(Date.now()/1e3)
    // Calculates the total number of docs
    stats.total = _.reduce( _.pluck(decades, 'count'), function(sum, c) {
      return sum + c;
    }, 0);
    res.json(stats);
  });
};
