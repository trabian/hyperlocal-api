require.paths.unshift '.'

express = require 'express'

exports.boot = (config, next) ->

  require('app/models').load(config)

  { AccountsController, MembersController } = require('./app/controllers').load(config)

  app = express.createServer()

  app.get '/members.json', MembersController.index
  app.get '/members/:id.json', MembersController.show

  app.get '/members/:member_id/accounts.json', AccountsController.index
  app.get '/accounts/:id.json', AccountsController.show

  next app

unless module.parent

  config =
    database: 'mongodb://localhost/hyperlocal_api'
    port: 3001

  exports.boot config, (app) ->
    console.log "Started API server on port #{config.port}. You can access it at http://localhost:#{config.port}/members.json"
    app.listen config.port
    return app
