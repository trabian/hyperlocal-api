vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

samplePayee =
  name: "Bay Energy"
  nickname: "Utility Bill"
  account_number: "555 Test St"
  phone: '(555) 123-4567'
  payee_notes: 'Utilities'
  payee_category: 'frequent'
  address:
    street_1: "555 Test St"
    street_2: "Apt 103"
    city: 'San Francisco'
    state: 'CA'
    zip: '94118'

vows.describe('Payee Accounts').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    'Payee account details at the URL referenced in the list':

      topic: ->

        api.request.getWithCallback urls.payees.list, null, (err, req, res) =>

          payees = res.body.data

          if payee = payees[0]
            api.request.getWithCallback payee.urls.detail, null, (err, req, res) =>
              fetchedAccount = res.body.data
              if fetchedAccount.payee?
                console.log "The data hash returned contained a 'payee' element. The 'data' hash should contain the payee account data without an intermediate object."
                @callback err, fetchedAccount.payee, payee
              else
                @callback err, fetchedAccount, payee
          else
            @callback "External account list was empty"

        return

      'should be the same account requested': (err, payeeAccount, requestedAccount) ->
        throw err if err?
        assert.equal payeeAccount.id, requestedAccount.id

      'should include fields:': api.structure.assertFields 'urls', 'name', 'nickname', 'account_number', 'phone', 'payee_category', 'payee_type'

      'should include valid dates:': api.structure.assertDates 'created_date', 'last_payment_date', 'minimum_next_payment_date'

      'should have an address': api.structure.assertAddress 'address'

      'with urls':

        topic: (payee) ->
          @callback null, payee.urls

        'should include fields:': api.structure.assertFields 'detail', 'history'

        'fetching history':

          topic: (urls) ->
            api.request.getWithCallback urls.history, null, @callback
            return

          'should return a 200 response': api.assertStatus 200

          '(the data)': api.structure.assertDataFormat

    'Creating a payee account':

      topic: ->
        api.request.postWithCallback urls.payees.create, samplePayee, @callback

      'it should return a 200 response': api.assertStatus 200

      '(the new account)':

        topic: (req, res) ->
          if res.body.data
            @callback null, res.body.data
          else
            @callback "Payee wasn't created."
          return

        'should be returned': (payee) ->
          assert.ok payee

        'should include fields:': api.structure.assertFields 'id', 'urls', 'status'

        'should match the posted account': (payee) ->
          for key, value of samplePayee
            assert.deepEqual payee[key], value

        'accessed at the provided url':

          topic: (payee) ->
            api.request.getWithCallback payee.urls.detail, null, @callback
            return

          'should return a 200': api.assertStatus 200

          'should be present': (err, req, res) ->
            assert.ok res.body.data

        'when deleting':

          topic: (payee) ->
            api.request.deleteWithCallback payee.urls.detail, null, (err, req, res) =>
              @callback err, req, res, payee
            return

          'should return a 200': api.assertStatus 200

          'and fetched again':

            topic: (req, res, payee) ->
              api.request.getWithCallback payee.urls.detail, null, @callback
              return

            'should return a 200': api.assertStatus 200

            'should be marked deleted': (err, req, res) ->
              assert.match res.body.data.status, /^deleted_/

          'and when the account list is fetched':

            topic: (req, res, payee) ->

              api.request.getWithCallback urls.payees.list, null, (err, req, res) =>

                payees = res.body.data

                @callback err, payees, payee

              return

            'the account should be returned but marked as deleted': (err, payees, payee) ->

              markedDeleted = false

              for account in payees when account.id is payee.id
                markedDeleted = !! (account.status.match /^deleted_/)

              assert.isTrue markedDeleted

.export module
