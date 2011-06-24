mongoose = require 'mongoose'
_ = require 'underscore'

exports.load = (settings) ->

  settings.mongoose = mongoose

  mongoose.connect settings.database

  models = {}

  _.each ['Account', 'Member', 'Transaction'], (name) ->
    models[name] = mongoose.model name, require("./#{name.toLowerCase()}")

  settings.models = models
