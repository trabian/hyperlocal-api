Faker = require 'lib/Faker'
async = require 'async'
_ = require 'underscore'

{ RandomHelper } = require 'app/helpers'

module.exports =

  createMultiple: (options) =>

    samples = _.values(module.exports.samples)

    # Let's include all of them for now
    # startingAccount = 0

    # accountCount = 2 + Math.floor(Math.random() * (samples.length - 1))

    createAccount = (sample, accountCallback) ->

      options.sample = sample

      module.exports.create options, (account) ->
        options.onCreate(account, accountCallback)

    async.forEach samples, createAccount, options.callback

    # async.parallel (createAccount for num in [1..accountCount]), options.callback

  create: (options, callback) =>

    { member, sample, models } = options

    id = "#{member._id}-#{sample.suffix}"

    balance = RandomHelper.inRange(sample.min, sample.max).toFixed(2)

    availableBalance = 0

    if options.sample.type == 'share'
      availableBalance = (balance - RandomHelper.inRange(0, 300)).toFixed(2)
    else
      availableBalance = (balance - sample.min).toFixed(2)

    account = new models.Account
      _id: id
      member_id: member._id
      name: sample.name
      balance: balance
      available_balance: availableBalance
      type: sample.type

    account.nickname = "My #{sample.name} Account" if Math.random() < 0.5

    account.save ->
      callback account

  samples:

    "checking":
      name: "Checking"
      min: 200.0
      max: 15000.0
      suffix: "S10"
      type: "share"

    "share_savings":
      name: "Share Savings"
      min: 5.0
      max: 3500.0
      suffix: "S1"
      type: "share"

    "auto":
      name: "Auto Loan"
      min: -10000.0
      max: -500.0
      suffix: "L10"
      type: "loan"

    "heloc":
      name: "Home Equity Line of Credit"
      min: -40000.0
      max: -500.0
      suffix: "L21"
      type: "loan"
