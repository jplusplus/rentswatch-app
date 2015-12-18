var sqldb = require('../../sqldb'),
        _ = require('lodash'),
        Q = require('q');

// Gets all ads
var all = module.exports.all = function() {
  var deferred = Q.defer();
  // Build a query to get every trustable ads
  var query = [
    'SELECT total_rent, living_space, latitude, longitude',
    'FROM ad',
    'WHERE total_rent IS NOT NULL',
    'AND total_rent < 3000',
    'AND living_space < 200',
    'AND price_per_sqm < 70',
    'AND price_per_sqm > 3',
  ].join("\n");
  // For better performance we use a poolConnection
  sqldb.mysql.getConnection(function(err, connection) {
    // We use the given connection
    connection.query(query, function(err, rows) {
      if(err) deferred.reject(err);
      else deferred.resolve(rows);
      // And done with the connection.
      connection.release();
    });
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

// Count rents by decades
var decades = module.exports.decades = function() {
  var deferred = Q.defer();
  // Build a query to get every trustable ads
  var query = [
    'SELECT',
      '10 * (total_rent div 10) as "from",',
      '10 * (total_rent div 10) + 10 as "to",',
      'COUNT(id) as "count"',
    'FROM ad',
    'WHERE total_rent IS NOT NULL',
    'AND total_rent < 3000',
    'AND living_space < 200',
    'GROUP BY total_rent div 10'
  ].join("\n");
  // For better performance we use a poolConnection
  sqldb.mysql.getConnection(function(err, connection) {
    // We use the given connection
    connection.query(query, function(err, rows, fields) {
      if(err) deferred.reject(err);
      else deferred.resolve(rows, fields);
      // And done with the connection.
      connection.release();
    });
  });
  // Return the promise
  return deferred.promise;
};

var losRegression = module.exports.losRegression = function() {
  // Return the promise
  return all().then(function(rows) {
    // Pluck two values at a time
    var values = _.reduce(rows, function(res, row) {
      res.x.push(row.total_rent);
      res.y.push(row.living_space);
      return res;
    }, { x:[], y:[] });

    var sum_xy = sum_xx = 0;

    for (var i = 0; i < values.y.length; i++) {
      sum_xy += (values.x[i]*values.y[i]);
      sum_xx += (values.x[i]*values.x[i]);
    }

    return sum_xy / sum_xx;
  })
};
