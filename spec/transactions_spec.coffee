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

          'should include pagination': (err, req, res) ->

            page = res.body.page

            assert.ok page, "No 'page' object was found at the top level"

            assert.include page, 'next'

          '(the data)':

            topic: (req, res) ->
              @callback null, res.body.data
              return

            'should be present': (data) ->
              assert.ok data, "The 'data' element wasn't returned at the top level of the response body"

            "should be an array of objects": (data) ->
              assert.isArray data

          'pagination': api.structure.assertPagination

.export module

#       topic: api.request.get urls.transactions.all

#       'should return a 200 response': api.assertStatus 200

#       '(the data)':

#         topic: (req, res) ->
#           @callback null, res.body.data
#           return

#         'should be present': (data) ->
#           assert.ok data, "The 'data' element wasn't returned at the top level of the response body"

#         "should be an array of objects": (data) ->
#           assert.isArray data

#       '(individual transfers)':

#         topic: (req, res) ->
#           @callback null, if (_.isArray res.body.data) then res.body.data else res.body.data.transfers
#           return

#         "each transfer should have a 'schedule' object": (transfers) ->

#           if _.isEmpty transfers
#             console.log 'This member did not have any transfers available'
#           else
#             for transfer in transfers
#               assert.include transfer, 'schedule'

#     'Posting a transfer':

#       topic: api.request.get urls.accounts.list

#       '(with accounts)':

#         topic: (req, res) ->
#           @callback null, res.body.data
#           return

#         'an internal transfer':

#           topic: (accounts) ->

#             source = accounts[0]
#             destination = accounts[1]

#             transfer =
#               amount: 100
#               source_id: source.id
#               source_type: 'internal'
#               destination_id: destination.id
#               destination_type: 'internal'
#               schedule:
#                 type: 'now'
#               transfer_type: 'transfer'

#             api.request.postWithCallback urls.transfers.create, transfer, @callback

#             return

#           'should return a 200 response': api.assertStatus 200

#         'with external accounts':

#           topic: (accounts) ->

#             api.request.getWithCallback urls.externalAccounts.list, null, (err, req, res) =>

#               externalAccounts = res.body.data

#               unless _.isArray externalAccounts
#                 console.log "FYI: external accounts array was not at root of 'data' object, but we're checking for that in another test so we'll let this one slide."
#                 externalAccounts = externalAccounts.external_accounts

#               if _.isEmpty externalAccounts
#                 @callback 'External accounts are empty for this member'
#               else
#                 @callback null, accounts, externalAccounts

#               return

#           'and an external destination':

#             topic: (accounts, externalAccounts) ->

#               source = accounts[0]
#               destination = externalAccounts[0]

#               transfer =
#                 amount: 100
#                 source_id: source.id
#                 source_type: 'internal'
#                 destination_id: destination.id
#                 destination_type: 'external'
#                 schedule:
#                   type: 'now'
#                 transfer_type: 'transfer'

#               api.request.postWithCallback urls.transfers.create, transfer, @callback

#               return

#             'should return a 200 response': api.assertStatus 200

#           'and an external source':

#             topic: (accounts, externalAccounts) ->

#               source = externalAccounts[0]
#               destination = accounts[0]

#               transfer =
#                 amount: 100
#                 source_id: source.id
#                 source_type: 'external'
#                 destination_id: destination.id
#                 destination_type: 'internal'
#                 schedule:
#                   type: 'now'
#                 transfer_type: 'transfer'

#               api.request.postWithCallback urls.transfers.create, transfer, @callback

#               return

#             'should return a 200 response': api.assertStatus 200

# .export module
