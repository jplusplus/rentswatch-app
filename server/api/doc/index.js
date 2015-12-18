'use strict';

var express = require('express');
var controller = require('./doc.controller');
var response = require('../response');

var router = express.Router();

router.get('/all.png', response.cachedPng(), controller.all);
router.get('/center.png', response.cachedPng(), controller.center);
router.get('/stats.json', response.cachedJson(), controller.stats);

module.exports = router;
