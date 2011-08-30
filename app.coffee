require.paths.unshift '.'
require.paths.unshift './node_modules'

express = require 'express'

exports.boot = (next) ->

  RedisStore = require('connect-redis') express

  app = express.createServer express.logger(),
    express.bodyParser(),
    express.methodOverride(),
    express.cookieParser(),
    express.session
      secret: 'hyperlocal'
      store: new RedisStore
      key: 'session_id'

  app.configure 'production', ->
    app.set 'authenticate', true

  app.use (req, res, next) ->

    originalEnd = res.end

    res.end = (body) ->
      console.log 'Response:', body if body?
      originalEnd body

    do next

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
