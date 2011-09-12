{ ResponseHelper } = require 'app/helpers'

async = require 'async'
_ = require 'underscore'

module.exports =

  load: (app) ->

    { Institution } = app.settings.models

    fields = ["name", "routing_number", "states"]

    app.get '/institutions', (req, res) ->

      query = req.param('q')
      page = req.param('page') or 0
      pageSize = 20

      Institution
        .search(query)
        .sort('name', 1, 'state', 1, 'city', 1)
        .execFind (err, institutions) ->

          found = {}
          combined = []

          for institution in institutions

            key = institution.routing_number
            state = institution.state
            state = null if _.isEmpty state

            if (index = found[key]) >= 0
              existing = combined[index]
              existing.states.push state unless _.isNull(state) || _.include(existing.states, state)
            else
              found[key] = combined.length
              combined.push
                name: institution.name
                routing_number: institution.routing_number
                states: _.compact [state]

          start = page * pageSize
          end = start + pageSize

          pageData =
            next: "/institutions?page=#{page + 1}"

          res.send
            data: combined[start...end]
            page: pageData
