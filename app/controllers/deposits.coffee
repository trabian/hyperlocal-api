{ ResponseHelper } = require 'app/helpers'

async = require 'async'
_ = require 'underscore'

fs = require 'fs'
path = require 'path'

module.exports =

  load: (app) ->

    # {  } = app.settings.models

    # fields = module.exports.fields

    app.post '/deposits/image/:side.json', (req, res) ->

      req.form.complete (err, fields, files) ->
        console.log 'err', err if err?
        console.log 'complete', files.file
        res.writeHead 200
        res.end()

      # imageFile = path.join process.cwd(), "temp/deposit-#{Date.now()}.jpg"

      # console.log 'body', req.body

      # fs.writeFile imageFile, req.body, "binary", (err) ->
      #   res.writeHead 200
      #   res.end()
