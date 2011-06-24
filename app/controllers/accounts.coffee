{ ResponseHelper } = require 'app/helpers'

module.exports =

  load: (app) ->

    { Account, Member } = app.settings.models

    fields = ["name", "nickname", "balance", "available_balance"]

    app.get '/members/:member_id/accounts.json', (req, res) ->

      Account.find { member_id: req.params.member_id }, (err, accounts) ->
        ResponseHelper.sendCollection res, accounts, { fields, err }

    app.get '/accounts/:id.json', (req, res) ->

      Account.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }
