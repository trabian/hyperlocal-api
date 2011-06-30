{ RandomHelper } = require 'app/helpers'

TransactionSeed = require 'app/seeds/transactions/base'

module.exports = class PaycheckTransactionSeed extends TransactionSeed

  create: (date, i, callback) =>

    posted_at = RandomHelper.timeInDay date

    transaction = new @options.models.Transaction
      account_id: @options.account._id
      posted_at: posted_at
      amount: @options.paycheckAmount
      name: 'Direct Deposit: BigCo'
      category: "Paycheck"

    transaction.save callback
