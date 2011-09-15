assert = require 'assert'
_ = require 'underscore'

assertDataFormat =
  topic: (req, res) ->
    @callback null, res.body.data
    return

  'should be present': (data) ->
    assert.ok data, "The 'data' element wasn't returned at the top level of the response body"

  "should be an array of objects": (data) ->

    message = ->
      if data
        "Instead we got a hash with the following key(s): #{_.keys(data).join ', '}"
      else
        "Instead it was empty."

    assert.isArray data, "The top level 'data' element should return an array. #{do message}"

assertField = (fieldName) ->
  (object) ->
    assert.ok object, "Expected object to include #{fieldName}, but it was empty instead"
    assert.include object, fieldName

assertFields = (fieldNames...) ->

  macro =
    topic: (object) ->
      @callback null, object
      return

  macro[fieldName] = assertField fieldName for fieldName in fieldNames

  macro

module.exports =

  load: (api) ->

    assert: (url) ->

      topic: api.request.get url

      'should return a 200 response': api.assertStatus 200

      '(the data)': assertDataFormat

    assertDataFormat: assertDataFormat

    assertField: assertField

    assertFields: assertFields

    assertAddress: (field) ->

      topic: (object) ->
        @callback null, object[field]
        return

      'with fields:': assertFields 'street_1', 'city', 'state', 'zip'

    assertPagination:

      topic: (req, res) ->
        @callback null, res.body.page

      'should be present': (err, page) ->
        assert.ok page, "No 'page' object was found at the top level"

      'should include a "next" field': (err, page) ->
        assert.include page, 'next'
