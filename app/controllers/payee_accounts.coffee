{ ResponseHelper } = require 'app/helpers'

async = require 'async'
_ = require 'underscore'

module.exports =

  fields: ["name", "nickname", "account_number", "address", "phone", "payee_notes", "payee_category", 'payee_type', "status", "minimum_next_payment_date", "last_payment_date", "created_date", "urls"]

  load: (app) ->

    { PayeeAccount } = app.settings.models

    fields = module.exports.fields

    app.post '/members/:member_id/accounts/payee', (req, res) ->

      data = req.body

      account = new PayeeAccount
        member_id: req.params.member_id
        name: data.name
        nickname: data.nickname
        account_number: data.account_number
        address: data.address
        phone: data.phone
        payee_notes: data.payee_notes
        payee_category: data.payee_category
        payee_type: 'electronic'
        status: "Active"

      account.save (err, doc) =>
        console.log 'doc', doc
        ResponseHelper.send res, doc, { fields, err }

    app.get '/members/:member_id/accounts/payee', (req, res) ->

      PayeeAccount.find(member_id: req.params.member_id)
                   .sort('priority', 1)
                   .execFind (err, payees) ->

          ResponseHelper.sendCollection res, payees, { fields, err }


    app.get '/accounts/payee/:id', (req, res) ->

      PayeeAccount.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }

    app.put '/accounts/payee/:id', (req, res) ->

      data = req.body.account

      PayeeAccount.update { _id: req.params.id }, { nickname: data.nickname }, =>
        res.send {}

    app.del '/accounts/payee/:id', (req, res) ->

      PayeeAccount.update { _id: req.params.id }, { status: 'deleted_by_user' }, =>
        res.writeHead 200
        res.end()
