{ ResponseHelper } = require 'app/helpers'

async = require 'async'

module.exports =

  load: (app) ->

    { Institution } = app.settings.models

    fields = ["name", "routing_number", "address", "city", "state", "zip"]

    app.get '/institutions.json', (req, res) ->

      query = req.param('q')
      page = req.param('page') or 1
      pageSize = 20

      Institution
        .search(query)
        .sort('name', 1, 'state', 1, 'city', 1)
        .limit(pageSize)
        .skip((page - 1) * pageSize)
        .execFind (err, institutions) ->
          ResponseHelper.sendCollection res, institutions, { fields, err }
