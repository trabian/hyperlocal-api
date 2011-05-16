require.paths.unshift '.'

Faker = require './lib/Faker'
async = require 'async'
_ = require 'underscore'

config =
  database: 'mongodb://localhost/hyperlocal_api'

require('app/models').load(config)

{ Account, Member } = config.models

mongoose = config.mongoose

membersToCreate = 5

timer = "create #{membersToCreate} members"

console.time timer

memberSeed = require('./seeds/member')
accountSeed = require('./seeds/account')

mongoose.connection.db.dropDatabase ->

  memberOptions =
    startingId: 123001
    models: config.models
    count: membersToCreate
    onCreate: (member, callback) ->

      accountOptions =
        member: member
        models: config.models

      accountSeed.createMultiple accountOptions, callback

  memberSeed.createMultiple memberOptions, ->
    console.timeEnd timer
    mongoose.connection.close()
