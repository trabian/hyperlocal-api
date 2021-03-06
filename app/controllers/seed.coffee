Seeder = require 'app/seeds/seeder'

module.exports =

  load: (app) ->

    models = app.settings.models

    app.get '/seed', (req, res) ->

      count = req.param('count')
      startTime = new Date().getTime()

      seeder = new Seeder
        models: models
        count: count

      seeder.seed ->
        duration = new Date().getTime() - startTime
        res.send "Created #{count} members in #{duration} milliseconds"

    app.get '/seed/institutions', (req, res) ->
      startTime = new Date().getTime()

      seeder = new Seeder
        models: models

      seeder.seedInstitutions ->
        duration = new Date().getTime() - startTime
        res.send "Loaded institutions in #{duration} milliseconds"
