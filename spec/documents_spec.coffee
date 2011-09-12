vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

vows.describe('Documents').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'eStatement list':

      topic: api.request.get urls.estatements.list

      'should return a 200 response': api.assertStatus 200

      '(the data)': api.structure.assertDataFormat

      'pagination': api.structure.assertPagination

      'with a sample eStatement':

        topic: (req, res) ->

          estatements = res.body.data

          unless _.isArray estatements
            console.log "FYI: estatements array was not at root of 'data' object, but we're checking for that in another test so we'll let this one slide."
            estatements = estatements.estatements

          @callback null, estatements[0]

        'it should contain at least one document': (estimate) ->
          assert.ok estimate

        'it should have a "url" field': (estatement) ->
          assert.include estatement, 'url'

        'it should have a valid "date" field': (estatement) ->
          assert.include estatement, 'date'
          assert.isNumber (Date.parse estatement.date), 'The date should be in ISO 8601 format'

        'it should have a "description" field': (estatement) ->
          assert.include estatement, 'description'

        'and the associated pdf':

          topic: (estatement) ->
            api.request.getWithCallback estatement.url, null, @callback
            return

          'should return a 200 response': api.assertStatus 200

          'should be a PDF': (err, req, res) ->
            assert.equal res.headers['content-type'], 'application/pdf'

.export module
