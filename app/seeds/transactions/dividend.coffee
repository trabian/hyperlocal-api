{ RandomHelper } = require 'app/helpers'

TransactionSeed = require 'app/seeds/transactions/base'

module.exports = class DividendTransactionSeed extends TransactionSeed

  create: (date, i, callback) =>

    posted_at = RandomHelper.timeInDay date

    transaction = new @options.models.Transaction
      account_id: @options.account._id
      posted_at: posted_at
      amount: @options.amount
      name: 'Dividend'
      category: "Dividend"

    transaction.save callback
