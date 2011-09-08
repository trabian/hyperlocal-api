assert = require 'assert'

module.exports =

  load: (apiUrl, memberNumber) ->

    api = {}

    requests = (require './requests').load api, apiUrl, memberNumber

    api.authenticate = requests.authenticate
    api.request = requests.request

    api.assertStatus = (code) ->
      (err, req, res) -> assert.equal res?.statusCode, code

    structure = (require './structure').load api

    api.assertStructure = structure.assert

    api
