require.paths.unshift '.'
require.paths.unshift './node_modules'

express = require 'express'

exports.boot = (next) ->

  app = express.createServer()

  app.use express.bodyParser()
  app.use express.methodOverride()

  app.set 'database', process.env.MONGOHQ_URL ? 'mongodb://localhost/hyperlocal_api'
  app.set 'port', 3001

  app.get '/test', (req, res) ->
    res.send 'Testing'

  require('app/models').load app.settings 
  require('app/controllers').load app

  next app

unless module.parent

  exports.boot (app) ->
    port = process.env.PORT || app.set('port')
    console.log "Started API server on port #{port} using db: #{app.set('database')}. You can access it at http://localhost:#{port}/members.json"
    app.listen port
    return app
