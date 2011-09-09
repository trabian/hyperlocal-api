_ = require 'underscore'

_.templateSettings =
  interpolate : /\{\{(.+?)\}\}/g

assert = require 'assert'

apiUrl = process.env.API_URL
memberNumber = process.env.MEMBER_NUMBER

requests = (require './requests').load apiUrl, memberNumber

module.exports =

  urls: require './urls'

  requests: requests

  authenticate: requests.authenticate
  request: requests.request

  assertStatus: (code) ->
    (err, req, res) -> assert.equal res?.statusCode, code, "Expected a 200 response, but got #{res.statusCode} with body: #{res.body}"

  template: (string, locals) ->

    _.template string, locals

module.exports.structure = (require './structure').load module.exports
