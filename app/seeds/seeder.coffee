async = require 'async'

memberSeed = require('app/seeds/member')
accountSeed = require('app/seeds/account')
institutionSeed = require('app/seeds/institution')

module.exports = class Seeder

  constructor: (@options) ->

  seed: (callback) ->

    { Member, Account, ExternalAccount, Transaction, Transfer, TransferInstance } = @options.models

    dropCollection = (collection, callback) ->
      collection.remove {}, callback

    async.forEach [Member, Account, ExternalAccount, Transaction, Transfer, TransferInstance], dropCollection, (err) =>
      if err 
        console.log 
      else
        @createMembers callback

  seedInstitutions: (callback) ->

    { Institution } = @options.models

    Institution.remove {}, =>
      institutionSeed.createMultiple @options, callback

  createMembers: (callback) =>

    memberSeed.createMultiple
      startingId: 123001
      models: @options.models
      count: @options.count
      onCreate: @createAccounts
      callback: callback

  createAccounts: (member, callback) =>

    accountSeed.create
      member: member
      models: @options.models
      callback: callback
