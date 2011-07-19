mongoose = require 'mongoose'
_ = require 'underscore'

exports.load = (settings) ->

  settings.mongoose = mongoose

  mongoose.connect settings.database

  models = {}

  modelFiles =
    Account: 'account'
    ExternalAccount: 'external_account'
    Institution: 'institution'
    Member: 'member'
    Transaction: 'transaction'

  for name, file of modelFiles
    models[name] = mongoose.model name, require("./#{file}")

  settings.models = models
