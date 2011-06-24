{ ResponseHelper } = require 'app/helpers'

module.exports =

  load: (app) ->

    { Member } = app.settings.models

    fields = ["first_name", "middle_name", "last_name", "phone", "address"]

    app.get '/members.json', (req, res) ->

      Member.find {}, (err, members) ->
        ResponseHelper.sendCollection res, members, { fields, err }

    app.get '/members/:id.json', (req, res) ->

      Member.findById req.params.id, (err, member) ->
        ResponseHelper.send res, member, { fields, err }
