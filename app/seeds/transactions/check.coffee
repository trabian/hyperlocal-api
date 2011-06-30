{ RandomHelper } = require 'app/helpers'

TransactionSeed = require 'app/seeds/transactions/base'

module.exports = class CheckTransactionSeed extends TransactionSeed

  create: (date, i, callback) =>

    posted_at = RandomHelper.timeInDay date

    transaction = new @options.models.Transaction
      account_id: @options.account._id
      posted_at: posted_at
      amount: @options.amount
      name: "Check ##{@options.number}"
      check_number: @options.number
      type: "check"

    transaction.save callback
