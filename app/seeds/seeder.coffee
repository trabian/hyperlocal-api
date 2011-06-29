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
        @loadMerchants (@merchants) =>
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
      onCreate: @createTransactions
      callback: callback

  createTransactions: (account, callback) =>

    if account.name is "Checking"

      transactionSeed.createMultiple
        account: account
        models: @options.models
        merchants: @merchants
        days: 120
        callback: callback

    else
      callback()

  loadMerchants: (callback) =>

    merchants = []

    onData = (data) ->
      merchants.push
        name: data[0].trim()
        id: data[1]
        min: +data[2]
        max: +data[3]
        nickname: data[4]
        category: data[5]

    onComplete = ->
      callback merchants

    csv
      .each("fixtures/merchants.csv")
      .addListener('data', onData)
      .addListener('end', onComplete)
