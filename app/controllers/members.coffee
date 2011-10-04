path = require 'path'
fs = require 'fs'

{ ResponseHelper } = require 'app/helpers'

async = require 'async'

creditMatrix =
  "a+": "800 (+)"
  "a": "760-799"
  "a-": "720-759"
  "b+": "700-719"
  "b": "680-699"
  "b-": "660-679"
  "c+": "650-659"
  "c": "640-649"
  "c-": "630-639"
  "d+": "620-629"
  "d": "610-619"
  "d-": "600-609"
  "e+": "560-599"
  "e": "520-559"
  "e-": "480-519"
  "f": "479"

module.exports =

  fields: ["first_name", "middle_name", "last_name", "email_address", "phone_list", "res_address", "mailing_address", "custom_account_sort", "last_login", "tier_group", "tier_group_last_updated"]

  load: (app) ->

    fields = module.exports.fields

    { Account, Member } = app.settings.models

    app.get '/members', (req, res) ->

      Member.find {}, (err, members) ->
        ResponseHelper.sendCollection res, members, { fields, err }

    app.get '/members/:id/creditgrade/detail', (req, res) ->

      res.send
        data:
          last_updated: new Date()
          credit_matrix: creditMatrix

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

