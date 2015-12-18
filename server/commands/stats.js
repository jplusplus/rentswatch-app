#!/usr/bin/env node
'use strict';
// Load .env files (if needed)
require('../env')();

var fs = require('fs'),
   doc = require("../api/doc/doc.model"),
prompt = require('prompt'),
  argv = require('yargs').argv;

// Override prompt values with argv
prompt.override = argv
// Start the prompt
prompt.message = '';
prompt.delimiter = '';
prompt.start();

prompt.get([{
  name: 'output',
  type: 'string',
  default: 'stats.json',
  description: "Name of the ouput file:".magenta
}], function (err, params) {
  var stats = {};
  console.log("Extracting data...");
  // Extracting decades...
  doc.decades().then(function(decades) {
    stats.decades = decades;
    // Extracting slope...
    doc.losRegression().then(function(slope) {
      stats.slope = slope;
      console.log("Saving stats...");
      fs.writeFile(params.output, JSON.stringify(stats, null, 2), process.exit);
    });
  });
});
