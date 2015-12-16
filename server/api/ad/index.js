'use strict';

var express = require('express');
var controller = require('./ad.controller');
var response = require('../response');

var router = express.Router();

router.get('/all.png', response.cachedPng(), controller.index);
router.get('/center.png', response.cachedPng(), controller.center);

module.exports = router;
