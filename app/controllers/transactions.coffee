{ ResponseHelper } = require 'app/helpers'

module.exports =

  load: (app) ->

    { Account, Transaction } = app.settings.models

    fields = ["name", "nickname", "amount", "posted_at", "type"]

    app.get '/accounts/:account_id/transactions.json', (req, res) ->

      count = req.param('count') ? 10

      Transaction
        .find(account_id: req.params.account_id)
        .limit(count)
        .sort('posted_at', -1)
        .execFind (err, transactions) ->
          ResponseHelper.sendCollection res, transactions, { fields, err }

    app.get '/transactions/:id.json', (req, res) ->

      Transaction.findById req.params.id, (err, transaction) ->
        ResponseHelper.send res, transaction, { fields, err }
