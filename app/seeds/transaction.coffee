Faker = require 'lib/Faker'
async = require 'async'
_ = require 'underscore'

{ RandomHelper } = require 'app/helpers'

module.exports =

  createTransactionsForDay: (options, day, callback) ->

    createTransaction = (number, callback) ->

      # Pick a random merchant
      options.merchant = RandomHelper.inArray options.merchants

      date = new Date()

      date.setDate date.getDate() - day
      date.setHours RandomHelper.inRange(0, 24)
      date.setMinutes RandomHelper.inRange(0, 60)

      options.posted_at = date

      module.exports.create options, callback

    transactionsForDay = RandomHelper.inRange(0, 5)

    async.forEach [0..transactionsForDay], createTransaction, callback

  createMultiple: (options) =>

    createFunction = async.apply(module.exports.createTransactionsForDay, options)

    async.forEach [0..options.days], createFunction, options.callback

  create: (options, callback) =>

    { account, models, merchant, posted_at } = options

    { Transaction } = models

    transaction = new Transaction
      account_id: account._id
      name: merchant.name
      amount: -RandomHelper.inRange(merchant.min, merchant.max).toFixed(2)
      posted_at: posted_at

    transaction.save ->
      callback transaction
