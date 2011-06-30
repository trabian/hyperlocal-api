_ = require 'underscore'
async = require 'async'
csv = require 'lib/csv'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

DividendTransactionSeed = require 'app/seeds/transactions/dividend'

module.exports = class SavingsAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    @options = _.defaults _.clone(@options),
      name: "Share Savings"
      suffix: "S11"
      type: "share"
      availableBalance: RandomHelper.amountInRange 5, 20000
      daysToCreate: 120
      pendingTransactions: 0
      dividendDay: 12

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    # seeds.push (seedCallback) =>

    #   merchantSeed = new MerchantTransactionSeed
    #     account: account
    #     models: @options.models
    #     merchants: @options.merchants

    #   merchantSeed.createManyForDay date, seedCallback

    if date.getDate() == @options.dividendDay

      seeds.push (seedCallback) =>

        dividendSeed = new DividendTransactionSeed
          account: account
          models: @options.models
          amount: 13.45

        dividendSeed.create date, 0, seedCallback

    async.parallel seeds, callback
