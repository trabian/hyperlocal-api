Faker = require 'lib/Faker'
async = require 'async'
_ = require 'underscore'

{ RandomHelper } = require 'app/helpers'

CheckingAccountSeed = require 'app/seeds/accounts/checking'

module.exports =

  createMultiple: (options) =>

    samples = _.values(module.exports.samples)

    createAccount = (sample, accountCallback) ->
      options.sample = sample
      module.exports.create options, accountCallback

    createAccount null, options.callback

    # async.forEach samples, createAccount, options.callback

  create: (options, callback) =>
    (new CheckingAccountSeed options).create callback

  samples:

    "share_savings":
      name: "Share Savings"
      min: 5.0
      max: 3500.0
      suffix: "S1"
      type: "share"

    "auto":
      name: "Auto Loan"
      min: -10000.0
      max: -500.0
      suffix: "L10"
      type: "loan"

    "heloc":
      name: "Home Equity Line of Credit"
      min: -40000.0
      max: -500.0
      suffix: "L21"
      type: "loan"
