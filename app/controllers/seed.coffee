Faker = require 'lib/Faker'
async = require 'async'

module.exports =

  load: (settings) ->

    { Account, Member } = settings.models

    mongoose = settings.mongoose

    memberSeed = require('../seeds/member')
    accountSeed = require('../seeds/account')

    actions =

      index: (req, res) ->

        count = req.param('count')

        startTime = new Date().getTime()

        dropCollection = (collection, callback) ->
          collection.remove {}, callback

        async.forEach [Member, Account], dropCollection, (err) ->

          if err
            console.log err

          else
            memberOptions =
              startingId: 123001
              models: settings.models
              count: count
              onCreate: (member, callback) ->

                accountOptions =
                  member: member
                  models: settings.models

                accountSeed.createMultiple accountOptions, callback

            memberSeed.createMultiple memberOptions, ->
              duration = new Date().getTime() - startTime
              res.send "Created #{count} members in #{duration} milliseconds"
