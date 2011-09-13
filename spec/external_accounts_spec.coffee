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

    'External account details should be available at the URL referenced in the list':

      topic: ->

        api.request.getWithCallback urls.externalAccounts.list, null, (err, req, res) =>

          externalAccounts = res.body.data

          unless _.isArray externalAccounts
            console.log "FYI: external accounts array was not at root of 'data' object, but we're checking for that in another test so we'll let this one slide."
            externalAccounts = externalAccounts[_.keys(externalAccounts)[0]]

          if externalAccount = externalAccounts[0]
            api.request.getWithCallback externalAccount.url, null, (err, req, res) =>
              fetchedAccount = res.body.data
              if fetchedAccount.external_account?
                @callback "The data hash returned contained an 'external_account' element. The 'data' hash should contain the external account data without an intermediate object."
              else
                @callback err, fetchedAccount, externalAccount
          else
            @callback "External account list was empty"

        return

      'should be the same account requested': (err, externalAccount, requestedAccount) ->
        throw err if err?
        assert.equal externalAccount.id, requestedAccount.id

    'Creating a new external account':

      topic: ->
        api.request.postWithCallback urls.externalAccounts.create, sampleExternalAccount, @callback

      'it should return a 200 response': api.assertStatus 200

      '(the new account)':

        topic: (req, res) ->
          if res.body.data
            @callback null, res.body.data
          else
            @callback "External account wasn't created."
          return

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
            return

          'should return a 200': api.assertStatus 200

          'should be present': (err, req, res) ->
            assert.ok res.body.data

.export module
