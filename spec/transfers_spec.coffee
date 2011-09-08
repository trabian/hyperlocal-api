vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

vows.describe('Transfers').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'Transfer list':

      topic: api.request.get urls.transfers.all

      'should return a 200 response': api.assertStatus 200

      '(the data)':

        topic: (req, res) ->
          @callback null, res.body.data
          return

        'should be present': (data) ->
          assert.ok data, "The 'data' element wasn't returned at the top level of the response body"

        "should be an array of objects": (data) ->
          assert.isArray data

      '(individual transfers)':

        topic: (req, res) ->
          @callback null, if (_.isArray res.body.data) then res.body.data else res.body.data.transfers
          return

        "each transfer should have a 'schedule' object": (transfers) ->

          if _.isEmpty transfers
            console.log 'This member did not have any transfers available'
          else
            for transfer in transfers
              assert.include transfer, 'schedule'

    'Posting a transfer':

      topic: api.request.get urls.accounts.list

      '(with accounts)':

        topic: (req, res) ->
          @callback null, res.body.data
          return

        'if the required fields are present':

          topic: (accounts) ->

            source = accounts[0]
            destination = accounts[1]

            transfer =
              amount: 100
              source_id: source.id
              source_type: 'internal'
              destination_id: destination.id
              destination_type: 'internal'
              schedule:
                type: 'now'
              transfer_type: 'transfer'

            api.request.postWithCallback urls.transfers.create, transfer, @callback

            return

          'it should return a 200 response': api.assertStatus 200

.export module
