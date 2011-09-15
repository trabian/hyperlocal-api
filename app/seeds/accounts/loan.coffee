_ = require 'underscore'
async = require 'async'

{ RandomHelper } = require 'app/helpers'

AccountSeed = require 'app/seeds/accounts/base'

LoanTransactionSeed = require 'app/seeds/transactions/loan_payment'

module.exports = class LoanAccountSeed extends AccountSeed

  constructor: (@options = {}) ->

    balance = - RandomHelper.inRange 200, 15000
    originalAmount = balance - RandomHelper.inRange 500, 1000

    dueDate = new Date()
    dueDate.setDate dueDate.getDate() + RandomHelper.amountInRange 3, 10

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
      current_rate: RandomHelper.amountInRange 2, 5
      amount_due: RandomHelper.amountInRange 200, 500
      orig_loan_amt: originalAmount.toFixed 2
      account_opened: originalDate
      due_date: dueDate
      term: "5 years"

  createTransactionsForDay: (account, date, callback) =>

    seeds = []

    if date.getDate() == (new Date date.getYear(), date.getMonth() + 1, 0).getDate()

      seeds.push (seedCallback) =>

        loanSeed = new LoanTransactionSeed
          account: account
          models: @options.models
          rate: @options.current_rate
          payment_amount: @options.amount_due

        loanSeed.create date, 0, seedCallback

    async.parallel seeds, callback
