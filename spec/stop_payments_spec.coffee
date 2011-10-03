vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

sampleStopPayment =
  start: 100
  end: 300

url = api.template urls.stopPayments.create,
  account_id: "S10"

vows.describe('Stop payment').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'Posting a stop payment':

      topic: api.request.post url, sampleStopPayment

      'should return a 200': api.assertStatus 200

.export module
