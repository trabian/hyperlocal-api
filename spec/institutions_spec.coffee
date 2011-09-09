vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

vows.describe('Institution lookup').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    "matches list with a sample query ('community')":

      topic: ->

        url = api.template urls.institutions.list,
          query: 'community'

        api.request.getWithCallback url, null, @callback

        return

      'should return a 200 response': api.assertStatus 200

      '(the data)': api.structure.assertDataFormat

      'pagination': api.structure.assertPagination

      'with a sample institution':

        topic: (req, res) ->

          institutions = res.body.data

          unless institutions
            @callback "Response body did not include a 'data' object at the root"
            return

          unless _.isArray institutions
            console.log "FYI: institutions array was not at root of 'data' object, but we're checking for that in another test so we'll let this one slide."
            institutions = institutions[_.keys(institutions)[0]]

          @callback null, institutions[0]

          return

        'it should have an "id" field': (institution) ->
          assert.include institution, 'id'

        'it should have a "routing_number" field': (institution) ->
          assert.include institution, 'routing_number'

        'it should have a "name" field': (institution) ->
          assert.include institution, 'name'

        'it should have a valid "states" field': (institution) ->
          assert.include institution, 'states'
          assert.isArray institution.states

.export module
