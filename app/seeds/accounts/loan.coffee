_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

LoanTransactionSeed = require 'app/seeds/transactions/loan_payment'

module.exports = class LoanAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    balance = - RandomHelper.inRange 200, 15000
    originalAmount = balance - RandomHelper.inRange 500, 1000

    nextPaymentDate = new Date()
    nextPaymentDate.setDate nextPaymentDate.getDate() + RandomHelper.amountInRange 3, 10

    originalDate = new Date()
    originalDate.setDate originalDate.getDate() - RandomHelper.amountInRange 500, 1200

    @options = _.defaults _.clone(@options),
      name: "Auto Loan"
      suffix: "L10"
      type: "loan"
      balance: balance.toFixed 2
      daysToCreate: 120
      priority: 2
      checking: false
      rate: RandomHelper.amountInRange 2, 5
      payment_amount: RandomHelper.amountInRange 200, 500
      original_amount: originalAmount.toFixed 2
      original_date: originalDate
      next_payment_date: nextPaymentDate
      term: (RandomHelper.inRange 2, 5).toFixed 0

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    if date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      seeds.push (seedCallback) =>

        loanSeed = new LoanTransactionSeed
          account: account
          models: @options.models
          rate: @options.rate
          payment_amount: @options.payment_amount

        loanSeed.create date, 0, seedCallback

    async.parallel seeds, callback
