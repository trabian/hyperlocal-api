Faker = require 'lib/Faker'
async = require 'async'
_ = require 'underscore'

{ RandomHelper } = require 'app/helpers'

module.exports =

  addBalances: (options, callback) ->

    account = options.account

    pendingTransactionsToCreate = Math.floor(RandomHelper.inRange(0, 10))
    transactionCount = 0

    addBalance = (transaction, callback) ->

      balance = account.seedBalance = (account.seedBalance - account.previousAmount).toFixed(2)

      if transactionCount < pendingTransactionsToCreate
        transaction.pending = true
      else if transactionCount == pendingTransactionsToCreate
        account.balance = balance
        account.save()

      transactionCount = transactionCount + 1

      account.previousAmount = transaction.amount

      transaction.balance = balance

      transaction.save callback

    options.models.Transaction
      .find(account_id: account.id)
      .sort('posted_at', -1)
      .execFind (err, transactions) ->

        account.seedBalance = account.available_balance
        account.previousAmount = 0

        async.forEachSeries transactions, addBalance, options.callback

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

    date = new Date()

    date.setDate date.getDate() - day

    createCallback = ->
      async.forEach [0..transactionsForDay], createTransaction, callback

    if date.getDate() == 15 or date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      transaction = new options.models.Transaction
        account_id: options.account._id
        name: "Direct Deposit: BigCo"
        amount: options.paycheckAmount
        posted_at: date

      transaction.save createCallback

    else
      createCallback()

  createMultiple: (options) =>

    options.account.seedBalance = options.account.available_balance
    options.account.previousAmount = 0

    options.paycheckAmount = RandomHelper.inRange(2000, 6000).toFixed 2

    createFunction = async.apply(module.exports.createTransactionsForDay, options)
    callback = async.apply(module.exports.addBalances, options)

    async.forEach [0..options.days], createFunction, callback

  create: (options, callback) =>

    { account, models, merchant, posted_at } = options

    { Transaction } = models

    amount = -RandomHelper.inRange(merchant.min, merchant.max).toFixed(2)

    transaction = new Transaction
      account_id: account._id
      name: merchant.name
      amount: amount
      posted_at: posted_at

    if Math.random() < 0.5
      transaction.nickname = merchant.nickname

    if Math.random() < 0.5
      transaction.category = merchant.category

    transaction.save callback
