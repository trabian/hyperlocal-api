path = require 'path'
fs = require 'fs'

{ ResponseHelper } = require 'app/helpers'

module.exports =

  load: (app) ->

    { Account, Transaction } = app.settings.models

    fields = ["name", "nickname", "amount", "posted_at", "type", "balance", "category", "dividend_rate", "dividend_balance", "check_number", "note"]

    app.get '/accounts/:account_id/transactions.json', (req, res) ->

      count = req.param('count') ? 10
      before = req.param 'before'

      query = Transaction
        .find(account_id: req.params.account_id)
        .limit(count)
        .sort('posted_at', -1)

      query = query.lt 'posted_at', before if before?

      query.execFind (err, transactions) ->
        ResponseHelper.sendCollection res, transactions, { fields, err }

    app.get '/transactions/:id.json', (req, res) ->

      Transaction.findById req.params.id, (err, transaction) ->
        ResponseHelper.send res, transaction, { fields, err }

    app.get '/transactions/:id/check/:side.jpg', (req, res) ->

      checkFile = path.join process.cwd(), "fixtures/checks/#{req.param('side')}.jpg"

      fs.readFile checkFile, "binary", (err, file) ->
        res.writeHead 200
        res.write file, "binary"
        res.end()

    app.put '/transactions/:id.json', (req, res) ->

      Transaction.findById req.params.id (err, transaction) ->
        transaction.save req.params.transaction, (err, transaction) ->
          ResponseHelper.send res, transaction, { fields, err }
