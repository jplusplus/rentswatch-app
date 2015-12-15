'use strict';

var express = require('express');
var controller = require('./ad.controller');
var response = require('../response');

var router = express.Router();

router.get('/', response.cachedPng(), controller.index);
router.get('/center', response.cachedPng(), controller.center);

module.exports = router;
