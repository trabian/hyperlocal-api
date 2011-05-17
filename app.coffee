require.paths.unshift '.'

express = require 'express'

exports.boot = (next) ->

  app = express.createServer()

  app.set 'database', 'mongodb://localhost/hyperlocal_api'
  app.set 'port', 3001

  require('app/models').load app.settings 
  require('app/controllers').load app

  next app

unless module.parent

  exports.boot (app) ->
    port = app.set('port')
    console.log "Started API server on port #{port}. You can access it at http://localhost:#{port}/members.json"
    app.listen port
    return app
