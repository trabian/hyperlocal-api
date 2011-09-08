assert = require 'assert'

module.exports =

  load: (api) ->

    assert: (url) ->

      topic: api.request.get url

      'should return a 200 response': api.assertStatus 200

      '(the data)':

        topic: (req, res, other) ->
          @callback null, res.body.data
          return

        'should be present': (data) ->
          assert.ok data, "The 'data' element wasn't return at the top level of the response body"

        "should be an array of objects": (data) ->
          assert.isArray data