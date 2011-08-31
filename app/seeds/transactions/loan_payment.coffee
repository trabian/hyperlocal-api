{ RandomHelper } = require 'app/helpers'

TransactionSeed = require 'app/seeds/transactions/base'

module.exports = class LoanPaymentTransactionSeed extends TransactionSeed

  create: (date, i, callback) =>

    posted_at = RandomHelper.timeInDay date

    account = @options.account

    amount = @options.payment_amount
    principal = 0
    interest = 0

    if Math.random() > 0.2
      principal= amount * 0.75 # Approximation
      interest = @options.payment_amount - principal

    balance = (account.balance - (principal || amount)).toFixed 2

    transaction = new @options.models.Transaction
      account_id: account._id
      posted_at: posted_at
      amount: amount.toFixed?(2) or amount
      principal: principal.toFixed? 2
      interest: interest.toFixed? 2
      name: 'Loan Payment'
      category: 'Loan Payment'
      balance: balance
      type: "loan_payment"

    transaction.save =>

      account.balance = balance

      @options.models.Account.update { _id: account.id },
        { balance: account.balance },
        (err, doc) =>
          callback()
