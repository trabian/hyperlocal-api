_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

DividendTransactionSeed = require 'app/seeds/transactions/dividend'

module.exports = class InvestmentAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    @options = _.defaults _.clone(@options),
      name: "Investment"
      suffix: "I10"
      type: "investment"
      balance: RandomHelper.amountInRange 5, 20000
      daysToCreate: 120
      checking: false
      pendingTransactions: 0
      dividendDay: 12
      current_rate: RandomHelper.amountInRange 0, 4
      priority: 1

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    if date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      seeds.push (seedCallback) =>

        dividendSeed = new DividendTransactionSeed
          account: account
          models: @options.models
          rate: @options.current_rate

        dividendSeed.create date, 0, seedCallback

    async.parallel seeds, callback
