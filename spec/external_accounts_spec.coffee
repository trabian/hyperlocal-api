vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

sampleExternalAccount =
  name: "Test CU"
  nickname: "My Test Account"
  account_owner_name: "Me"
  account_number: "43214321"
  routing_number: "12341234"

vows.describe('External Accounts').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'Creating a new external account':

      topic: ->
        api.request.postWithCallback urls.externalAccounts.create, sampleExternalAccount, @callback

      'it should return a 200 response': api.assertStatus 200

      '(the new account)':

        topic: (req, res) ->
          @callback null, res.body.data

        'should be returned': (externalAccount) ->
          assert.ok externalAccount

        'should include an "id" field': (externalAccount) ->
          assert.include externalAccount, 'id'

        'should include a "url" field': (externalAccount) ->
          assert.include externalAccount, 'url'

        'should match the posted account': (externalAccount) ->
          for key, value of sampleExternalAccount
            assert.equal externalAccount[key], value

        'accessed at the provided url':

          topic: (externalAccount) ->
            api.request.getWithCallback externalAccount.url, null, @callback

          'should return a 200': api.assertStatus 200

          'should be present': (err, req, res) ->
            assert.ok res.body.data

.export module
