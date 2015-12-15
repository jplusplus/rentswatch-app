var sqldb = require('./index'),
        _ = require('lodash'),
        Q = require('q');

// Gets all ads
var all = module.exports.all = function() {
  var deferred = Q.defer();
  // Build a query to get every trustable ads
  var query = [
    'SELECT total_rent, living_space, latitude, longitude',
    'FROM ad',
    'WHERE total_rent < 3000',
    'AND living_space < 200',
    'AND price_per_sqm < 70',
    'AND price_per_sqm > 3',
  ].join("\n");
  // Query the database
  sqldb.mysql.query(query, function(err, rows) {
    if(err) deferred.reject(err);
    else deferred.resolve(rows);
  });
  // Return the promise
  return deferred.promise;
};

// Gets all ads in a given radius
var center = module.exports.center = function(lat, lng, distance) {
  // Return the promise
  return all().then(function(rows) {
    // Convert KM radius in degree
    var deg = (distance || 20) * .01;
    // Return filtered rows
    return _.filter(rows, function(row) {
      // Just using some Pythagorian intersection
      var a = lng - row.longitude,
          b = lat - row.latitude;
      return Math.pow(a, 2) + Math.pow(b, 2) <= Math.pow(deg, 2)
    });
  });
};
