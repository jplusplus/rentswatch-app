'use strict';

// Production specific configuration
// =================================
module.exports = {
  // Server IP
  ip: process.env.OPENSHIFT_NODEJS_IP ||
      process.env.IP ||
      undefined,
  // Server port
  port: process.env.OPENSHIFT_NODEJS_PORT ||
        process.env.PORT ||
        8080,
  // MySQL connection options
  mysql: {
    uri: process.env.CLEARDB_DATABASE_URL ||
         process.env.DATABASE_URL ||
         'mysql://localhost/rentswatch'
  }
};
