{ ResponseHelper } = require 'app/helpers'

async = require 'async'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'

module.exports =

  fields: ["description", "date", "url"]

  load: (app) ->

    { Document } = app.settings.models

    fields = module.exports.fields

    app.get '/members/:member_id/documents', (req, res) ->

      count = req.param('count') ? 10
      page = req.param('page') ? 0

      Document.find(member_id: req.params.member_id)
               .sort('created_at', -1)
               .skip(count * page)
               .limit(count)
               .execFind (err, documents) ->

          pageData =
            next: "/members/#{req.params.member_id}/documents?page=#{page + 1}"

          ResponseHelper.sendCollection res, documents, { fields, err, pageData }

    app.get '/documents/:id.json', (req, res) ->

      Document.findById req.params.id, (err, statement) ->
        ResponseHelper.send res, statement, { fields, err }

    app.get '/documents/:id.pdf', (req, res) ->

      statementFile = path.join process.cwd(), "fixtures/documents/sample.pdf"

      fs.readFile statementFile, "binary", (err, file) ->
        res.header 'Content-Type', 'application/pdf'
        res.writeHead 200
        res.write file, "binary"
        res.end()

    # Just fake it for now
    app.post '/members/:member_id/documents/enrollment', (req, res) ->
      res.send {}
