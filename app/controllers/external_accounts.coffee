{ ResponseHelper } = require 'app/helpers'

async = require 'async'

module.exports =

  load: (app) ->

    { ExternalAccount } = app.settings.models

    fields = ["nickname", "institution", "routing_number", "account_number", "type", "priority"]

    app.post '/members/:member_id/accounts/external.json', (req, res) ->

      data = req.body.account

      account = new ExternalAccount
        member_id: req.params.member_id
        type: 'external'
        nickname: data.nickname
        institution: data.institution
        account_number: data.account_number
        routing_number: data.routing_number

      account.save (err, doc) =>
        ResponseHelper.send res, doc, { fields, err }

    app.get '/members/:member_id/accounts/external.json', (req, res) ->

      ExternalAccount.find(member_id: req.params.member_id)
             .sort('priority', 1)
             .execFind (err, accounts) ->

          ResponseHelper.sendCollection res, accounts, { fields, err }

    app.get '/accounts/external/:id.json', (req, res) ->

      ExternalAccount.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }

    app.put '/accounts/external/:id.json', (req, res) ->

      account = req.body.account

      ExternalAccount.update { _id: req.params.id }, { nickname: account.nickname }, =>
        res.send {}
