path = require 'path'
fs = require 'fs'
async = require 'async'
_ = require 'underscore'

{ ResponseHelper } = require 'app/helpers'

AccountController = require 'app/controllers/accounts'
ExternalAccountController = require 'app/controllers/external_accounts'
MemberAccountController = require 'app/controllers/member_accounts'
TransactionController = require 'app/controllers/transactions'

scheduleFields = ['type', 'start_at', 'end_at', 'frequency', 'last_occurrence', 'next_occurrence', 'state']

transferInstanceFields = ['created_at', 'source_transaction', 'destination_transaction']

module.exports =

  fields: ["source", "destination", "source_id", "source_type", "destination_id", "destination_type", "amount", "created_at", "schedule", "note", "instances"]

  load: (app) ->

    { Account, ExternalAccount, MemberAccount, Schedule, Transaction, Transfer, TransferInstance } = app.settings.models

    fields = module.exports.fields

    loadTransfers = (query, callback) ->

      query.execFind (err, transfers) ->

        if _.isEmpty transfers
          callback transfers, err
          return

        member_id = transfers[0].member_id + ""

        accounts = {}

        mapAccounts = (_accounts) =>

          hash = {}

          for account in _accounts
            hash[account.id] = account

          hash

        fetchInternal = (callback) =>
          Account.find { member_id }, (err, internal) ->
            accounts.internal = mapAccounts internal
            do callback

        fetchExternal = (callback) =>
          ExternalAccount.find { member_id }, (err, external) ->
            accounts.external = mapAccounts external
            do callback

        fetchMember = (callback) =>
          MemberAccount.find { member_id }, (err, member) ->
            accounts.member = mapAccounts member
            do callback

        accountFields = ['name', 'nickname', 'id', 'type', 'balance', 'available_balance', 'routing_number', 'account_number', 'member_number', 'member_name_verification']

        async.parallel [fetchInternal, fetchExternal, fetchMember], =>

          for transfer in transfers

            for association in ['source', 'destination']

              id = transfer["#{association}_id"]

              collection = switch transfer["#{association}_type"]
                when "external"
                  accounts.external
                when "member"
                  accounts.member
                else
                  accounts.internal

              transfer[association] = ResponseHelper.format collection[id], accountFields

            transfer.schedule = ResponseHelper.format transfer.schedule, scheduleFields, false

          callback transfers, err

    app.get '/members/:member_id/transfers', (req, res) ->

      count = req.param('count') ? 10
      member_id = req.params.member_id

      query = Transfer
        .find({ member_id })
        .limit(count)

      loadTransfers query, (transfers, err) ->
        ResponseHelper.sendCollection res, transfers, { fields, err }

    app.get '/accounts/:account_id/transfers', (req, res) ->

      count = req.param('count') ? 10

      query = Transfer
        .forAccount(req.params.account_id)
        .limit(count)

      loadTransfers query, (transfers, err) ->
        ResponseHelper.sendCollection res, transfers, { fields, err }

    app.get '/transfers/:id', (req, res) ->

      Transfer.findById req.params.id, (err, transfer) ->
        TransferInstance
          .find(transfer_id: req.params.id)
          .sort('created_at', -1)
          .execFind (err, instances) ->

            transfer.instances = instances.map (instance) ->
              ResponseHelper.format instance, transferInstanceFields

            ResponseHelper.send res, transfer, { fields, err }

    app.get '/transfers/instances/:id', (req, res) ->

      TransferInstance.findById req.params.id, (err, instance) ->

        loadTransaction = (field, callback) ->

          transactionId = instance["#{field}_transaction_id"]

          Transaction.findById transactionId, (err, transaction) ->

            accountOptions = switch transaction.account_type
              when "external"
                class: ExternalAccount
                fields: ExternalAccountController.fields
              when "member"
                class: MemberAccount
                fields: MemberAccountController.fields
              else
                class: Account
                fields: AccountController.fields

            accountOptions.class.findById transaction.account_id, (err, account) ->
              transaction.account = ResponseHelper.format account, accountOptions.fields
              instance["#{field}_transaction"] = ResponseHelper.format transaction, TransactionController.fields
              do callback

        async.forEach ['source', 'destination'], loadTransaction, ->
          ResponseHelper.send res, instance, { fields: transferInstanceFields, err: err }

    app.put '/transfers/:id', (req, res) ->

      Transfer.update { _id: req.params.id }, req.body.transfer, =>

        Transfer.findById req.params.id, (err, transfer) ->

          transfer.createTransactions (transfer) =>
            transfer.schedule = ResponseHelper.format transfer.schedule, scheduleFields, false
            ResponseHelper.send res, transfer, { fields, err }

    app.del '/transfers/:id', (req, res) ->

      Transfer.remove { _id: req.params.id }, =>
        res.send {}

    app.post '/transfers/:id', (req, res) ->

      if req.body.action is 'delete'

        Transfer.remove { _id: req.params.id }, =>
          res.send {}

      else
        res.send {}

    app.post '/members/:member_id/transfers', (req, res) ->

      data = req.body.transfer

      transfer = new Transfer
        member_id: req.params.member_id
        source_id: data.source_id
        source_type: data.source_type
        destination_id: data.destination_id
        destination_type: data.destination_type
        amount: data.amount
        schedule: data.schedule
        note: data.note
        payment_type: data.payment_type

      transfer.save (err, doc) =>

        transfer.createTransactions (transfer) =>

          transfer.schedule = ResponseHelper.format transfer.schedule, scheduleFields, false

          TransferInstance
            .find(transfer_id: transfer.id)
            .sort('created_at', -1)
            .execFind (err, instances) ->

              transfer.instances = []

              loadInstanceTransactions = (instance, callback) ->

                loadTransaction = (field, callback) ->

                  transactionId = instance["#{field}_transaction_id"]

                  if transactionId

                    Transaction.findById transactionId, (err, transaction) ->
                      instance["#{field}_transaction"] = ResponseHelper.format transaction, TransactionController.fields
                      do callback

                  else
                    do callback

                async.forEach ['source', 'destination'], loadTransaction, ->
                  transfer.instances.push ResponseHelper.format instance, transferInstanceFields
                  do callback

              async.forEach instances, loadInstanceTransactions, ->
                ResponseHelper.send res, transfer, { fields, err }
