vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

vows.describe('Transactions').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'Transfer list':

      topic: api.request.get urls.accounts.list

      '(with a sample account)':

        topic: (req, res) ->
          accounts = res.body.data
          @callback null, accounts[0]
          return

        'the list of transactions':

          topic: (account) ->

            shortAccountId = (id) ->
              if match = id.match(/(.)([S,L].*)/)
                console.log "!!! The account list returned ids in the long format (with member number) but we'll test for that elsewhere and shorten it for the sake of these tests."
                match[2]
              else
                id

            url = api.template urls.transactions.list,
              account_id: shortAccountId account.id

            api.request.getWithCallback url, null, @callback

            return

          'should return a 200 response': api.assertStatus 200

          '(the data)':

            topic: (req, res) ->
              @callback null, res.body.data
              return

            'should be present': (data) ->
              assert.ok data, "The 'data' element wasn't returned at the top level of the response body"

            "should be an array of objects": (data) ->
              assert.isArray data

          'A transaction':

            topic: (req, res) ->
              @callback null, res.body.data[0]
              return

            'should be present': (transaction) ->
              assert.ok transaction

            'should include a "pending" field': (transaction) ->
              assert.include transaction, 'pending'

          'pagination': api.structure.assertPagination

.export module
