'use strict';

var express = require('express');
var controller = require('./doc.controller');
var response = require('../response');

var router = express.Router();

router.get('/all.png', response.cachedPng(), controller.allPng);
router.get('/center.png', response.cachedPng(), controller.centerPng);
router.get('/center.json', response.cachedJson(), controller.centerJson);

module.exports = router;
