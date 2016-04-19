var sqldb = require('../../sqldb'),
        _ = require('lodash'),
        Q = require('q'),
haversine = require('haversine');

const DEFAULT_CENTER_DISTANCE = 5;
const MAX_TOTAL_RENT = module.exports.MAX_TOTAL_RENT = 3000;
const MAX_LIVING_SPACE = module.exports.MAX_LIVING_SPACE = 200;

var extractSlope = module.exports.extractSlope = function(rows) {
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
}

// Gets all ads
var save = module.exports.save = function(data) {
  var deferred = Q.defer();
  // For better performance we use a poolConnection
  sqldb.mysql.getConnection(function(err, connection) {
    // We use the given connection
    connection.query('INSERT INTO rent SET ?', data, function(err, rent) {
      if(err) deferred.reject(err);
      else deferred.resolve(rent);
      // And done with the connection.
      connection.release();
    });
  });
  // Return the promise
  return deferred.promise;
};

// Gets all ads
var all = module.exports.all = function() {
  var deferred = Q.defer();
  // Build a query to get every trustable ads
  var query = [
    'SELECT total_rent, living_space, latitude, longitude',
    'FROM ad',
    'WHERE total_rent IS NOT NULL',
    'AND total_rent < ' + MAX_TOTAL_RENT,
    'AND living_space < ' + MAX_LIVING_SPACE,
    'LIMIT 5000',
    'ORDER BY created_at DESC'
    //'AND price_per_sqm < 70',
    // 'AND price_per_sqm > 3',
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
var center = module.exports.center = function(lat, lon, radius) {
  // Return the promise
  var deferred = Q.defer();
  var limit = 5000;
  // We may use a default radius
  radius = radius || DEFAULT_CENTER_DISTANCE;
  // Convert degree in radian
  var rad = function(r) { return r * (Math.PI/180); };
  // Round value
  var rn =function(v) { return Math.round(v*1e9)/1e9; };
  // Compute square bounds
  var nlat = lat + radius / 110.574;
  var slat = lat - radius / 110.574;
  var wlon = lon - radius / (111.320 * Math.cos(rad(lat)));
  var elon = lon + radius / (111.320 * Math.cos(rad(lat)));
  // Build a query to get every trustable ads
  var query = [
    'SELECT total_rent, living_space, latitude, longitude, created_at',
    'FROM ad',
    'WHERE total_rent IS NOT NULL',
    'AND total_rent < ' + MAX_TOTAL_RENT,
    'AND living_space < ' + MAX_LIVING_SPACE,
    // For performance reason we filter the rows using
    // a simple square comparaison
    'AND ' + rn(nlat) + ' > latitude AND  ' + rn(slat) + ' < latitude',
    'AND ' + rn(wlon) + ' < longitude AND ' + rn(elon) + ' > longitude'
  ];
  // Should we limit the query
  if(limit && limit > 0) {
    query.push('ORDER BY created_at DESC');
    query.push('LIMIT ' + parseInt(limit) );
  }
  // For better performance we use a poolConnection
  sqldb.mysql.getConnection(function(err, connection) {
    // We use the given connection
    connection.query(query.join("\n"), function(err, rows) {
      if(err) deferred.reject(err);
      else {
        // We refilter every rows to have more precise selection
        deferred.resolve(_.filter(rows, function(row) {
          // Use haversine to calculate the distance between the points
          return haversine(row, {latitude: lat, longitude: lon}) < radius * 1e3;
        }));
      }
      // And done with the connection.
      connection.release();
    });
  });
  // Return the promise
  return deferred.promise;
};


// Count rents by deciles
var deciles = module.exports.deciles = function(rows) {
  var deferred = Q.defer();
  var deciles = [];
  // Create a range for every decile
  for(var i = 30; i < MAX_TOTAL_RENT;) {
    deciles.push({
      from: i,
      to: i + 10,
      count: _.filter(rows, function(row) {
        return row.total_rent && row.total_rent >= i && row.total_rent < i + 10;
      }).length
    });
    // Move from 10 to 10
    i += 10;
  }
  // We resolve a promise for retro-compatibility
  deferred.resolve(deciles);
  // Return the promise
  return deferred.promise;
};


var losRegression = module.exports.losRegression = function() {
  // Return the promise
  return all().then(extractSlope)
};

var centeredLosRegression = module.exports.losRegression = function(lat, lng, distance) {
  // Return the promise
  return center(lat, lng, distance).then(extractSlope)
};
