APIeasy = require 'api-easy'
assert = require 'assert'

config =
  port: '8002'
  host: 'localhost'
  database: 'mongodb://localhost/hyperlocal_api'

app = require('./app').boot config, (app) ->
  console.log "Starting test API server on port #{config.port}"
  app.listen config.port
  return app

suite = APIeasy.describe('/members.json')

vows = require 'vows'
vows.console = require 'vows/console'

result = vows.console.result

vows.console.result = (results) ->
  console.log 'test', app.close
  app.close()
  result.call vows.console, results

suite
  .discuss('The members API')
  .use(config.host, config.port)
  .setHeader('Content-Type', 'application/json')
  .get('/members.json')
  .expect(200)

suite.export(module)
