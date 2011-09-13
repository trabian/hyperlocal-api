{ ResponseHelper } = require 'app/helpers'

async = require 'async'
_ = require 'underscore'

module.exports =

  fields: ["nickname", "name", "routing_number", "account_owner_name", "account_number", "type", "priority", "withdrawable", "url"]

  load: (app) ->

    { ExternalAccount, PayeeAccount } = app.settings.models

    fields = module.exports.fields

    app.post '/members/:member_id/accounts/external', (req, res) ->

      data = req.body

      account = new ExternalAccount
        member_id: req.params.member_id
        type: 'external'
        nickname: data.nickname
        name: data.name
        account_number: data.account_number
        account_owner_name: data.account_owner_name
        routing_number: data.routing_number
        withdrawable: data.withdrawable

      if data.withdrawable is "verify_on_save"
        account.withdrawable = "pending"
        account.withdrawable_verification = [34, 56]

      account.save (err, doc) =>
        ResponseHelper.send res, doc, { fields, err }

    app.get '/members/:member_id/accounts/external', (req, res) ->

      ExternalAccount.find(member_id: req.params.member_id)
             .sort('priority', 1)
             .execFind (err, accounts) ->

          ResponseHelper.sendCollection res, accounts, { fields, err }

    app.get '/members/:member_id/accounts/payee', (req, res) ->

      PayeeAccount.find(member_id: req.params.member_id)
             .sort('priority', 1)
             .execFind (err, accounts) ->

          ResponseHelper.sendCollection res, accounts, { fields, err }

    app.get '/accounts/external/:id', (req, res) ->

      ExternalAccount.findById req.params.id, (err, account) ->
        ResponseHelper.send res, account, { fields, err }

    app.put '/accounts/external/:id', (req, res) ->

      data = req.body.account

      if verify_amounts = data.verify_withdrawal

        ExternalAccount.findById req.params.id, (err, account) ->
          if err
            res.send "Error finding account"
            console.log 'err', err
          else

            amounts = account.withdrawable_verification?[0..1]
            verify_amounts = (+amount for amount in verify_amounts) # Convert to integers

            if _.isEmpty _.without(verify_amounts, amounts...)

              # res.send
              #   data:
              #     withdrawable: 'verified'

              ExternalAccount.update { _id: req.params.id }, { withdrawable: 'verified', withdrawable_verification: null }, =>
                res.send
                  data:
                    withdrawable: 'verified'

            else
              res.send "Numbers didn't match", 403

      else
        ExternalAccount.update { _id: req.params.id }, { nickname: data.nickname }, =>
          res.send {}
