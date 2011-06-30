{ RandomHelper } = require 'app/helpers'

TransactionSeed = require 'app/seeds/transactions/base'

module.exports = class MerchantTransactionSeed extends TransactionSeed

  create: (date, i, callback) =>

    posted_at = RandomHelper.timeInDay date

    merchant = RandomHelper.inArray @options.merchants
    amount = -RandomHelper.amountInRange merchant.min, merchant.max

    transaction = new @options.models.Transaction
      account_id: @options.account._id
      posted_at: posted_at
      amount: amount
      name: merchant.name

    if Math.random() < 0.5
      transaction.nickname = merchant.nickname

    if Math.random() < 0.5
      transaction.category = merchant.category

    transaction.save callback
