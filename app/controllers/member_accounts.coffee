{ ResponseHelper } = require 'app/helpers'

async = require 'async'
_ = require 'underscore'

module.exports =

  fields: ["nickname", "member_number", "member_name_verification", "type"]

  load: (app) ->

    { MemberAccount } = app.settings.models

    fields = module.exports.fields

    app.post '/members/:member_id/accounts/member', (req, res) ->

      data = req.body.account

      account = new MemberAccount
        member_id: req.params.member_id
        type: 'member'
        nickname: data.nickname
        member_number: data.member_number
        member_name_verification: data.member_name_verification

      account.save (err, doc) =>
        ResponseHelper.send res, doc, { fields, err }

    app.get '/members/:member_id/accounts/member', (req, res) ->

      MemberAccount.find(member_id: req.params.member_id)
                   .sort('priority', 1)
                   .execFind (err, accounts) ->

          ResponseHelper.sendCollection res, accounts, { fields, err }

    app.get '/accounts/member/:id', (req, res) ->

      MemberAccount.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }

    app.put '/accounts/member/:id', (req, res) ->

      data = req.body.account

      MemberAccount.update { _id: req.params.id }, { nickname: data.nickname }, =>
        res.send {}
