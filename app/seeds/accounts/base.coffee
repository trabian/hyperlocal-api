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

    account.nickname = "My #{@options.name} Account" if Math.random() < 0.5

    account.save =>
      @createManyTransactions account, callback

  createId: ->
    [@options.member._id, @options.suffix].join '-'

  createManyTransactions: (account, callback) =>

    create = =>
      postDates = for daysAgo in [0..@options.daysToCreate]
        date = new Date()
        date.setDate date.getDate() - daysAgo
        date

      createTransactionsForDay = async.apply @createTransactionsForDay, account

      async.forEach postDates, createTransactionsForDay, callback

    if @beforeCreateManyTransactions?
      @beforeCreateManyTransactions account, create
    else
      create()
