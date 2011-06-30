{ RandomHelper } = require 'app/helpers'

TransactionSeed = require 'app/seeds/transactions/base'

module.exports = class DividendTransactionSeed extends TransactionSeed

  create: (date, i, callback) =>

    posted_at = RandomHelper.timeInDay date

    account = @options.account

    amount = account.balance * @options.rate
    balance = (account.balance + amount).toFixed 2

    transaction = new @options.models.Transaction
      account_id: account._id
      posted_at: posted_at
      amount: amount.toFixed(2)
      name: 'Dividend'
      category: "Dividend"
      dividend_rate: @options.rate
      dividend_balance: account.balance
      balance: balance
      type: "dividend"

    transaction.save =>

      account.balance = balance

      @options.models.Account.update { _id: account.id },
        { balance: account.balance },
        (err, doc) =>
          callback()
