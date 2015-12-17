'use strict';

var   ad = require('../../sqldb/ad'),
response = require("../response"),
       _ = require('lodash');

// Default cache duration
var CACHE_DURATION = 24*60*60*1000;

exports.index = function(req, res) {
  // Extracting ads...
  ad.all().then(function(rows) {
    try {
      // Drawing points...
      var canvas = require('../../canvas/ad').scatterplot(rows, 480*2);
    // Something may happen
    } catch(e) {
      return response.validationError(res)({ error: "Unbale to generate"});
    }

    var image = canvas.toBuffer();
    // Cache the result
    response.setCachedRequest(req, image, null, CACHE_DURATION);

    res.type('image/png');
    res.end(image, 'binary');
  });
};

exports.center = function(req, res) {
  // Check parameters
  if(!req.query.latlng) {
    return response.validationError(res)({ error: "'latlng' parameter must not be empty."});
  } else if( req.query.latlng.split(',').length !== 2 ) {
    return response.validationError(res)({ error: "'latlng' parameter is malformed."});
  }

  // Extract coordinates from query
  var center = _( req.query.latlng.split(',') )
    // Remove whitespaces
    .map(_.trim)
    // Cast to fload
    .map(Number)
    // Since coordinates are usually formulated as latitude and longitude pair,
    // we have to turn the coordinates array upside down
    .reverse()
    // Return values
    .value()
  // Extracting ads...
  ad.center.apply(null, center).then(function(rows) {
    try {
      // Drawing points...
      var canvas = require('../../canvas/ad').scatterplot(rows, 600, 400);
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
