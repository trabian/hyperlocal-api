Faker = require '../lib/Faker'
async = require 'async'
_ = require 'underscore'

randomNumberInRange = (lower, upper) ->
  lower + Math.random() * (upper - lower)

module.exports =

  createMultiple: (options, callback) =>

    samples = _.values(module.exports.samples)

    startingAccount = 0
    accountCount = 1 + Math.floor(Math.random() * samples.length)

    createAccount = (accountCallback) ->

      options.sample = samples[startingAccount++]

      module.exports.create options, (account) ->
        accountCallback()

    async.parallel (createAccount for num in [1..accountCount]), callback

  create: (options, callback) =>

    { member, sample } = options

    id = "#{member._id}-#{options.sample.suffix}"

    balance = randomNumberInRange(options.sample.min, options.sample.max).toFixed(2)

    availableBalance = 0

    if options.sample.type == 'share'
      availableBalance = (balance - randomNumberInRange(0, 300)).toFixed(2)
    else
      availableBalance = (balance - options.sample.min).toFixed(2)

    account = new options.models.Account
      _id: id
      member_id: member._id
      name: options.sample.name
      balance: balance
      available_balance: availableBalance

    account.nickname = "My #{options.sample.name} Account" if Math.random() < 0.5

    account.save callback

  samples:

    "share_savings":
      name: "Share Savings"
      min: 5.0
      max: 3500.0
      suffix: "S1"
      type: "share"

    "checking":
      name: "Checking"
      min: 200.0
      max: 15000.0
      suffix: "S10"
      type: "share"

    "auto":
      name: "Auto Loan"
      min: -10000.0
      max: -500.0
      suffix: "S10"
      type: "loan"

    "heloc":
      name: "Home Equity Line of Credit"
      min: -40000.0
      max: -500.0
      suffix: "L21"
      type: "loan"
