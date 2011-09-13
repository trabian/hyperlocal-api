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
  account_class: 'savings'
  account_permission: 'transfer_to'

vows.describe('Member details').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'The member details':

      topic: (session) ->
        @callback null, session.member_details
        return

      'should be returned in the session': (member) ->
        assert.ok member, '"member_details" object was unavailable'

      'should include fields:': api.structure.assertFields 'first_name', 'middle_name', 'last_name', 'phone_list', 'res_address', 'alt_address'

      'should have a res_address': api.structure.assertAddress 'res_address'

      'should have a alt_address': api.structure.assertAddress 'alt_address'

#     'Creating a new external account':

#       topic: ->
#         api.request.postWithCallback urls.externalAccounts.create, sampleExternalAccount, @callback

#       'it should return a 200 response': api.assertStatus 200

#       '(the new account)':

#         topic: (req, res) ->
#           if res.body.data
#             @callback null, res.body.data
#           else
#             @callback "External account wasn't created."
#           return

#         'should be returned': (externalAccount) ->
#           assert.ok externalAccount

#         'should include an "id" field': (externalAccount) ->
#           assert.include externalAccount, 'id'

#         'should include a "url" field': (externalAccount) ->
#           assert.include externalAccount, 'url'

#         'should include a "verified" field': (externalAccount) ->
#           assert.include externalAccount, 'verified'

#         'should include a "status" field': (externalAccount) ->
#           assert.include externalAccount, 'status'

#         'should match the posted account': (externalAccount) ->
#           for key, value of sampleExternalAccount
#             assert.equal externalAccount[key], value

#         'accessed at the provided url':

#           topic: (externalAccount) ->
#             api.request.getWithCallback externalAccount.url, null, @callback
#             return

#           'should return a 200': api.assertStatus 200

#           'should be present': (err, req, res) ->
#             assert.ok res.body.data

#         'when deleting':

#           topic: (externalAccount) ->
#             api.request.deleteWithCallback externalAccount.url, null, (err, req, res) =>
#               @callback err, req, res, externalAccount
#             return

#           'should return a 200': api.assertStatus 200

#           'and fetched again':

#             topic: (req, res, externalAccount) ->
#               api.request.getWithCallback externalAccount.url, null, @callback
#               return

#             'should return a 200': api.assertStatus 200

#             'should be marked deleted': (err, req, res) ->
#               assert.match res.body.data.status, /^deleted_/

#           'and when the account list is fetched':

#             topic: (req, res, externalAccount) ->

#               api.request.getWithCallback urls.externalAccounts.list, null, (err, req, res) =>

#                 externalAccounts = res.body.data

#                 unless _.isArray externalAccounts
#                   console.log "FYI: external accounts array was not at root of 'data' object, but we're checking for that in another test so we'll let this one slide."
#                   externalAccounts = externalAccounts[_.keys(externalAccounts)[0]]

#                 @callback err, externalAccounts, externalAccount

#               return

#             'the account should be returned but marked as deleted': (err, externalAccounts, externalAccount) ->

#               markedDeleted = false

#               for account in externalAccounts when account.id is externalAccount.id
#                 markedDeleted = !! (account.status.match /^deleted_/)

#               assert.isTrue markedDeleted

.export module
