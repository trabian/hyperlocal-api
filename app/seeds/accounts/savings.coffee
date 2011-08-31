_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

DividendTransactionSeed = require 'app/seeds/transactions/dividend'

module.exports = class SavingsAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    @options = _.defaults _.clone(@options),
      name: "Share Savings"
      suffix: "S11"
      type: "share"
      balance: RandomHelper.amountInRange 5, 20000
      daysToCreate: 120
      checking: false
      pendingTransactions: 0
      dividendDay: 12
      rate: 0.0025
      priority: 1

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    if date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      seeds.push (seedCallback) =>

        dividendSeed = new DividendTransactionSeed
          account: account
          models: @options.models
          rate: @options.rate

        dividendSeed.create date, 0, seedCallback

    async.parallel seeds, callback
