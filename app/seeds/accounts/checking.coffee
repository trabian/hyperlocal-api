_ = require 'underscore'
async = require 'async'
csv = require 'lib/csv'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

CheckTransactionSeed = require 'app/seeds/transactions/check'
MerchantTransactionSeed = require 'app/seeds/transactions/merchant'
PaycheckTransactionSeed = require 'app/seeds/transactions/paycheck'

module.exports = class CheckingAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    @startingCheckNumber = 4323

    @options = _.defaults _.clone(@options),
      name: "Checking"
      suffix: "S10"
      type: "share"
      checking: true
      availableBalance: RandomHelper.amountInRange 200, 15000
      daysToCreate: 120
      paycheckAmount: RandomHelper.amountInRange 1500, 6000
      pendingTransactions: Math.floor RandomHelper.inRange 0, 10
      addBalancesAtEnd: true
      priority: 0

  beforeCreateManyTransactions: (account, callback) =>
    @loadMerchants callback

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    seeds.push (seedCallback) =>

      merchantSeed = new MerchantTransactionSeed
        account: account
        models: @options.models
        merchants: @options.merchants

      merchantSeed.createManyForDay date, seedCallback

    # 15th and last day of month
    if date.getDate() == 15 or date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      seeds.push (seedCallback) =>

        paycheckSeed = new PaycheckTransactionSeed
          account: account
          models: @options.models
          paycheckAmount: @options.paycheckAmount

        paycheckSeed.create date, 0, seedCallback

    if Math.random() < 0.2

      seeds.push (seedCallback) =>

        checkSeed = new CheckTransactionSeed
          account: account
          models: @options.models
          number: @startingCheckNumber++
          amount: - RandomHelper.amountInRange 50, 200

        checkSeed.create date, 0, seedCallback

    async.parallel seeds, callback

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

    onComplete = =>
      @options.merchants = merchants
      callback()

    csv
      .each("fixtures/merchants.csv")
      .addListener('data', onData)
      .addListener('end', onComplete)
