#!/usr/bin/env node
'use strict';
// Load .env files (if needed)
require('../env')();

var Canvas = require('canvas'),
        fs = require('fs'),
        d3 = require('d3'),
         _ = require('lodash'),
    prompt = require('prompt'),
      argv = require('yargs').argv;

// Override prompt values with argv
prompt.override = argv
// Start the prompt
prompt.message = '';
prompt.delimiter = '';
prompt.start();

prompt.get([{
  name: 'center',
  type: 'string',
  description: "Get ads with 20km around:".magenta
},{
  name: 'output',
  type: 'string',
  default: 'scatterplot.png',
  description: "Name of the ouput image:".magenta
}], function (err, params) {

  // Create the promise according the parameters
  var promise = function() {
    if(params.center) {
      var center = params.center.split(",").reverse();
      return require("../sqldb/ad").center.apply(null, center)
    } else {
      return require("../sqldb/ad").all()
    }
  };

  console.log("Extracting data...");
  promise().then(function(rows) {
    console.log("Drawing %s points...", rows.length);
    var canvas = require('../canvas/ad').scatterplot(rows, 1200, 800);
    console.log("Saving plot...");
    fs.writeFile(params.output, canvas.toBuffer(), process.exit);
  });

});
