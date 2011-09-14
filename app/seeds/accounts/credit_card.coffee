_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

LoanTransactionSeed = require 'app/seeds/transactions/loan_payment'

module.exports = class CreditCardAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    balance = - RandomHelper.inRange 200, 15000
    limit = 15000

    dueDate = new Date()
    dueDate.setDate dueDate.getDate() + RandomHelper.amountInRange 3, 10

    @options = _.defaults _.clone(@options),
      name: "VISA"
      suffix: "L30"
      type: "credit_card"
      balance: balance.toFixed 2
      daysToCreate: 120
      priority: 2
      checking: false
      rate: RandomHelper.amountInRange 4, 8
      amount_due: RandomHelper.amountInRange 200, 500
      orig_loan_amt: 0
      availableBalance: (limit - balance).toFixed 2
      due_date: dueDate

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    if date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      seeds.push (seedCallback) =>

        loanSeed = new LoanTransactionSeed
          account: account
          models: @options.models
          rate: @options.rate
          payment_amount: @options.amount_due

        loanSeed.create date, 0, seedCallback

    async.parallel seeds, callback
