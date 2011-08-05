{ ResponseHelper } = require 'app/helpers'

async = require 'async'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'

module.exports =

  fields: ["name", "created_at"]

  load: (app) ->

    { Statement } = app.settings.models

    fields = module.exports.fields

    app.get '/members/:member_id/statements.json', (req, res) ->

      Statement.find(member_id: req.params.member_id)
               .sort('created_at', -1)
               .execFind (err, statements) ->

          ResponseHelper.sendCollection res, statements, { fields, err }

    app.get '/statements/:id.json', (req, res) ->

      Statement.findById req.params.id, (err, statement) ->
        ResponseHelper.send res, statement, { fields, err }

    app.get '/statements/:id.pdf', (req, res) ->

      statementFile = path.join process.cwd(), "fixtures/statements/sample.pdf"

      fs.readFile statementFile, "binary", (err, file) ->
        res.writeHead 200
        res.write file, "binary"
        res.end()

    # Just fake it for now
    app.post '/members/:member_id/statements/enrollment.json', (req, res) ->
      res.send {}
