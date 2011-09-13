Faker = require 'lib/Faker'
async = require 'async'
_ = require 'underscore'

{ RandomHelper } = require 'app/helpers'

SeedClasses = (require "app/seeds/accounts/#{seed}" for seed in ['checking', 'savings', 'line', 'loan', 'mortgage'])

module.exports =

  create: (options) =>

    seeds = []

    seeds = for seedClass in SeedClasses
      do (seedClass) ->
        (seedCallback) -> (new seedClass options).create seedCallback

    async.parallel seeds, options.callback
