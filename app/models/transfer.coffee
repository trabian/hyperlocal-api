async = require 'async'
_ = require 'underscore'

Schema = require('mongoose').Schema

ScheduleExtensions = require 'app/models/extensions/schedule'

Transfer = new Schema

  member_id: Number

  source_id: String
  source_type: String

  destination_id: String
  destination_type: String

  note: String

  amount: Number

  created_at:
    type: Date
    default: Date.now

  schedule:
    type:
      type: String # "type" is a special case
    start_at: Date
    end_at: Date
    frequency: String
    last_occurrence: ScheduleExtensions.lastOccurrence
    next_occurrence: ScheduleExtensions.nextOccurrence
    state: ScheduleExtensions.state

Transfer.static 'forAccount', (account_id, callback) ->

  orQuery = $or: [
    { 'source_id': account_id },
    { 'destination_id': account_id }
  ]

  @find orQuery, callback

Transfer.pre 'save', (next) ->

  if @schedule.type is 'now'
    @schedule.last_occurrence = new Date()

  do next

Transfer.method 'createTransactions', (callback) ->

  transfer = @

  { Account, ExternalAccount, MemberAccount, Transaction, TransferInstance } = Transfer.models

  createTransaction = (account_id, account_type, alternate_account_id, alternate_account_type, amount, transferInstance, direction, callback) ->

    transaction = new Transaction
      member_id: @member_id
      amount: amount
      account_id: account_id
      account_type: account_type
      name: "Transfer"
      posted_at: new Date()
      transfer_id: @id
      pending: true
      type: 'transfer'
      transfer_instance_id: transferInstance.id

    accountClasses = for type in [account_type, alternate_account_type]
      switch type
        when "external"
          internal: false
          class: ExternalAccount
        when "member"
          internal: false
          class: MemberAccount
        else
          internal: true
          class: Account

    account = accountClasses[0].class.findById account_id, (err, account) ->

      alternateAccount = accountClasses[1].class.findById alternate_account_id, (err, alternateAccount) ->

        transaction.name = "Transfer #{direction} #{alternateAccount.nickname or alternateAccount.name}"

        if accountClasses[0].internal
          available_balance = (account.available_balance or account.balance or 0) + transaction.amount
          Account.update { _id: account_id }, { available_balance: available_balance }, (err, account) ->
            transaction.balance = available_balance
            transaction.save callback
        else
          transaction.save callback

  if @schedule.type is 'now'

    TransferInstance.find {transfer_id: @id}, (err, instances) =>

      if _.isEmpty instances

        creators = []

        transferInstance = new TransferInstance
          transfer_id: @id
          created_at: @created_at

        transferInstance.save (err, transferInstance) =>

          @instances = [transferInstance]

          creators.push (callback) =>
            createTransaction @source_id, @source_type, @destination_id, @destination_type, -@amount, transferInstance, 'to', (err, doc) =>

              transferInstance.source = doc
              transferInstance.source_transaction_id = doc.id

              @save callback

          creators.push (callback) =>
            createTransaction @destination_id, @destination_type, @source_id, @source_type, @amount, transferInstance, 'from', (err, doc) =>

              transferInstance.destination = doc
              transferInstance.destination_transaction_id = doc.id

              @save callback

          async.parallel creators, ->
            transferInstance.save (err, doc) ->
              callback transfer

      else
        callback transfer

  else
    callback transfer

  return

module.exports = Transfer
