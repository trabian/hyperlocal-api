_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

LoanTransactionSeed = require 'app/seeds/transactions/loan_payment'

module.exports = class MortgageAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    balance = - RandomHelper.inRange 100000, 500000
    originalAmount = balance - RandomHelper.inRange 3000, (100000 - balance)

    dueDate = new Date()
    dueDate.setDate dueDate.getDate() + RandomHelper.amountInRange 3, 10

    originalDate = new Date()
    originalDate.setDate originalDate.getDate() - RandomHelper.amountInRange 500, 1200

    @options = _.defaults _.clone(@options),
      name: "555 Test Street"
      suffix: "S60"
      type: "mortgage"
      balance: balance.toFixed 2
      daysToCreate: 120
      priority: 2
      checking: false
      rate: RandomHelper.amountInRange 4, 7
      amount_due: RandomHelper.amountInRange 600, 3500
      original_amount: originalAmount.toFixed 2
      original_date: originalDate
      due_date: dueDate
      term: 30

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
