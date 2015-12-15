'use strict';

var mysql = require('mysql');
var config = require('../config/environment');
// Export the MySQL connection
module.exports =  {
  mysql: mysql.createConnection(config.mysql.uri)
};
