{ Authentication, ResponseHelper } = require 'app/helpers'

auth = Authentication.middleware

async = require 'async'

TransactionController = require 'app/controllers/transactions'

module.exports =

  fields: ["name", "nickname", "balance", "available_balance", "type", "transactions", "priority", "checking", "current_rate", "orig_loan_amt", "account_opened", "maturity_date", "due_date", "amount_due", "term", "urls", "credit_limit", 'billpay_source']

  load: (app) ->

    { Account, Member, Transaction } = app.settings.models

    fields = module.exports.fields

    stripIds = (accounts) ->

      # for account in accounts
      #   account._id = account._id.split('-')[1]

      accounts

    app.get '/members/:member_id/accounts', auth, (req, res) ->

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
            ResponseHelper.sendCollection res, (stripIds accounts), { fields, err }

        else
          ResponseHelper.sendCollection res, (stripIds accounts), { fields, err }

    app.get '/accounts/:id', auth, (req, res) ->

      Account.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }

    app.put '/accounts/:id', auth, (req, res) ->

      account = req.body.account

      Account.update { _id: req.params.id }, { nickname: account.nickname }, =>
        res.send {}

    app.post '/members/:member_id/accounts/sort', auth, (req, res) ->

      Member.update { _id: req.params.member_id }, { custom_account_sort: req.body.data }, =>
        res.send {}
