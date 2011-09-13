{ ResponseHelper } = require 'app/helpers'

async = require 'async'

module.exports =

  fields: ["first_name", "middle_name", "last_name", "phone_list", "res_address", "alt_address"]

  load: (app) ->

    fields = module.exports.fields

    { Account, Member } = app.settings.models

    app.get '/members.json', (req, res) ->

      Member.find {}, (err, members) ->
        ResponseHelper.sendCollection res, members, { fields, err }

    app.get '/members/:id.json', (req, res) ->

      Member.findById req.params.id, (err, member) ->
        ResponseHelper.send res, member, { fields, err }

    app.put '/members/:id.json', (req, res) ->

      member = req.body.member

      if member.accountOrder?

        order = 0

        updateAccountPriority = (accountId, callback) ->
          Account.update {_id: accountId}, { priority: order++}, callback

        async.forEachSeries member.accountOrder, updateAccountPriority, ->
          res.send {}

      else
        res.send {}
