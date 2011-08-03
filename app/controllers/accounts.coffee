{ ResponseHelper } = require 'app/helpers'

async = require 'async'

TransactionController = require 'app/controllers/transactions'

module.exports =

  fields: ["name", "nickname", "balance", "available_balance", "type", "transactions", "priority", "checking"]

  load: (app) ->

    { Account, Transaction } = app.settings.models

    fields = module.exports.fields

    app.get '/members/:member_id/accounts.json', (req, res) ->

      Account.find(member_id: req.params.member_id)
             .sort('priority', 1)
             .execFind (err, accounts) ->

        if transactionCount = req.param("transactions")

          loadTransactions = (account, callback) ->
            Transaction
              .find(account_id: account.id)
              .limit(transactionCount)
              .sort('posted_at', -1)
              .execFind (err, transactions) ->

                account.transactions = transactions.map (transaction) ->
                  ResponseHelper.format transaction, TransactionController.fields

                callback()

          async.forEach accounts, loadTransactions, ->
            ResponseHelper.sendCollection res, accounts, { fields, err }

        else
          ResponseHelper.sendCollection res, accounts, { fields, err }

    app.get '/accounts/:id.json', (req, res) ->

      Account.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }

    app.put '/accounts/:id.json', (req, res) ->

      account = req.body.account

      Account.update { _id: req.params.id }, { nickname: account.nickname }, =>
        res.send {}
