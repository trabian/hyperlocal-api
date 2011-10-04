path = require 'path'
fs = require 'fs'

{ ResponseHelper } = require 'app/helpers'

async = require 'async'

module.exports =

  fields: ["first_name", "middle_name", "last_name", "email_address", "phone_list", "res_address", "mailing_address", "custom_account_sort", "last_login", "tier_group", "tier_group_last_updated", "tier_group_range"]

  load: (app) ->

    fields = module.exports.fields

    { Account, Member } = app.settings.models

    app.get '/members', (req, res) ->

      Member.find {}, (err, members) ->
        ResponseHelper.sendCollection res, members, { fields, err }

    app.get '/members/:id/creditgrade/detail', (req, res) ->

      Member.creditMatrix (matrix) ->
        res.send
          data:
            last_updated: new Date()
            credit_matrix: matrix

    app.get '/members/:id/creditgrade/image', (req, res) ->

      checkFile = path.join process.cwd(), "fixtures/fico.jpg"

      fs.readFile checkFile, "binary", (err, file) ->
        res.header 'Content-Type', 'image/jpg'
        res.writeHead 200
        res.write file, "binary"
        res.end()

    app.get '/members/:id', (req, res) ->

      Member.findById req.params.id, (err, member) ->
        ResponseHelper.send res, member, { fields, err }

    app.post '/members/:id', (req, res) ->

      member = req.body

      Member.update { _id: req.params.id }, member, =>
        res.send {}

