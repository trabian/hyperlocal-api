Faker = require 'lib/Faker'
async = require 'async'
_ = require 'underscore'

{ RandomHelper } = require 'app/helpers'

SeedClasses = (require "app/seeds/accounts/#{seed}" for seed in ['checking', 'savings', 'loan', 'mortgage'])

module.exports =

  create: (options) =>

    seeds = []

    seeds = for seedClass in SeedClasses
      do (seedClass) ->
        (seedCallback) -> (new seedClass options).create seedCallback

    async.parallel seeds, options.callback

  samples:

    "heloc":
      name: "Home Equity Line of Credit"
      min: -40000.0
      max: -500.0
      suffix: "L21"
      type: "loan"
