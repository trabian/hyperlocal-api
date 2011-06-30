async = require 'async'

memberSeed = require('app/seeds/member')
accountSeed = require('app/seeds/account')
transactionSeed = require('app/seeds/transaction')

csv = require 'lib/csv'

module.exports = class Seeder

  constructor: (@options) ->

  seed: (callback) ->

    { Member, Account, Transaction } = @options.models

    dropCollection = (collection, callback) ->
      collection.remove {}, callback

    async.forEach [Member, Account, Transaction], dropCollection, (err) =>
      if err 
        console.log 
      else
        @createMembers callback

  createMembers: (callback) =>

    memberSeed.createMultiple
      startingId: 123001
      models: @options.models
      count: @options.count
      onCreate: @createAccounts
      callback: callback

  createAccounts: (member, callback) =>

    accountSeed.createMultiple
      member: member
      models: @options.models
      callback: callback
