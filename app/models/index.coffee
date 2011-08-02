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
    Transfer: 'transfer'
    TransferInstance: 'transfer_instance'

  for name, file of modelFiles
    schema = require("./#{file}")
    schema.models = models
    models[name] = mongoose.model name, schema

  settings.models = models
