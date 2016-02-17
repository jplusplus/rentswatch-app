var Canvas = require('canvas'),
        d3 = require('d3'),
         _ = require('lodash');

var doc = require("../api/doc/doc.model")

module.exports.scatterplot = function(rows, cvswidth, cvsheight, color) {
  // Default canvas sizes
  cvswidth  = cvswidth || 480*2;
  cvsheight = cvsheight || cvswidth || 480*2;

  var canvas = new Canvas(cvswidth, cvsheight);
  var ctx = canvas.getContext('2d');
  // Fill background
  // ctx.fillStyle = '#121119';
  // ctx.fillRect(0, 0, cvswidth, cvsheight);

  // Create scale for x (living_space)
  var x = d3.scale.linear().domain([0, doc.MAX_LIVING_SPACE]).range([0, cvswidth]);
  // Create scale for y (total_rent)
  var y = d3.scale.linear().domain([0, doc.MAX_TOTAL_RENT]).range([cvsheight, 0]);
  // Transparent image to allow
  ctx.globalAlpha = .7
  // Points color
  ctx.fillStyle = color || "#D35F5F";

  for(var r in rows) {
    var row = rows[r];
    ctx.fillRect( x(row.living_space), y(row.total_rent), 1, 1);
  }

  return canvas;
};

module.exports.losRegression = function(slope, cvswidth, cvsheight) {
  // Default canvas sizes
  cvswidth  = cvswidth || 480*2;
  cvsheight = cvsheight || cvswidth || 480*2;

  var canvas = new Canvas(cvswidth, cvsheight);
  var ctx = canvas.getContext('2d');

  // Create scale for x (living_space)
  var x = d3.scale.linear().domain([0, doc.MAX_LIVING_SPACE]).range([0, cvswidth]);
  // Points color
  ctx.strokeStyle = "#ffd633";

  ctx.beginPath();
  ctx.moveTo(0, cvsheight);
  ctx.lineWidth = 2;
  ctx.lineTo(x(doc.MAX_LIVING_SPACE), slope * x(doc.MAX_LIVING_SPACE) );
  ctx.stroke();

  return canvas;
};
