_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

module.exports = class AccountSeed

  create: (callback) =>

    account = new @options.models.Account
      _id: @createId()
      member_id: @options.member._id
      name: @options.name
      balance: @options.balance
      available_balance: @options.availableBalance
      type: @options.type
      priority: @options.priority
      checking: @options.checking
      rate: @options.rate
      orig_loan_amt: @options.orig_loan_amt
      account_opened: @options.account_opened
      maturity_date: @options.maturity_date
      amount_due: @options.amount_due
      due_date: @options.due_date
      term: @options.term
      limit: @options.limit

    account.nickname = "My #{@options.name} Account" if Math.random() < 0.5

    account.save (err, doc) =>
      @createManyTransactions doc, callback

  createId: ->
    [@options.member._id, @options.suffix].join '-'

  createManyTransactions: (account, callback) =>

    create = =>

      postDates = for daysAgo in [@options.daysToCreate..0]
        date = new Date()
        date.setDate date.getDate() - daysAgo
        date

      createTransactionsForDay = async.apply @createTransactionsForDay, account

      async.forEachSeries postDates, createTransactionsForDay, =>
        if @options.addBalancesAtEnd
          @addBalances account, callback
        else
          callback()

    if @beforeCreateManyTransactions?
      @beforeCreateManyTransactions account, create
    else
      create()

  addBalances: (account, callback) =>

    pendingTransactionsToCreate = @options.pendingTransactions

    transactionCount = 0

    addBalance = (transaction, callback) ->

      balance = account.seedBalance = (account.seedBalance - account.previousAmount).toFixed(2)

      if transactionCount < pendingTransactionsToCreate
        transaction.pending = true
      else if transactionCount == pendingTransactionsToCreate
        account.balance = balance
        account.save()

      transactionCount = transactionCount + 1

      account.previousAmount = transaction.principal || transaction.amount

      transaction.balance = balance

      transaction.save callback

    @options.models.Transaction
      .find(account_id: account.id)
      .sort('posted_at', -1)
      .execFind (err, transactions) ->

        account.seedBalance = account.available_balance
        account.previousAmount = 0

        async.forEachSeries transactions, addBalance, callback
