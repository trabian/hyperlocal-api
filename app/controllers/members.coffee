{ ResponseHelper } = require 'app/helpers'

async = require 'async'

module.exports =

  fields: ["first_name", "middle_name", "last_name", "phone_list", "res_address", "alt_address", "custom_account_sort"]

  load: (app) ->

    fields = module.exports.fields

    { Account, Member } = app.settings.models

    app.get '/members', (req, res) ->

      Member.find {}, (err, members) ->
        ResponseHelper.sendCollection res, members, { fields, err }

    app.get '/members/:id', (req, res) ->

      Member.findById req.params.id, (err, member) ->
        ResponseHelper.send res, member, { fields, err }
