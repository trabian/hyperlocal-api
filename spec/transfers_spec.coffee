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

      '(the data)': api.structure.assertDataFormat

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

        'an internal transfer':

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

          'should return a 200 response': api.assertStatus 200

        'with external accounts':

          topic: (accounts) ->

            api.request.getWithCallback urls.externalAccounts.list, null, (err, req, res) =>

              externalAccounts = res.body.data

              unless _.isArray externalAccounts
                console.log "FYI: external accounts array was not at root of 'data' object, but we're checking for that in another test so we'll let this one slide."
                externalAccounts = externalAccounts.external_accounts

              if _.isEmpty externalAccounts
                console.log 'here.'
                @callback 'External accounts are empty for this member'
              else
                console.log 'there'
                @callback null, accounts, externalAccounts

              return

          'and an external destination':

            topic: (err, accounts, externalAccounts) ->

              source = accounts[0]
              destination = externalAccounts[0]

              transfer =
                amount: 100
                source_id: source.id
                source_type: 'internal'
                destination_id: destination.id
                destination_type: 'external'
                schedule:
                  type: 'now'
                transfer_type: 'transfer'

              api.request.postWithCallback urls.transfers.create, transfer, @callback

              return

            'should return a 200 response': api.assertStatus 200

          'and an external source':

            topic: (accounts, externalAccounts) ->

              source = externalAccounts[0]
              destination = accounts[0]

              transfer =
                amount: 100
                source_id: source.id
                source_type: 'external'
                destination_id: destination.id
                destination_type: 'internal'
                schedule:
                  type: 'now'
                transfer_type: 'transfer'

              api.request.postWithCallback urls.transfers.create, transfer, @callback

              return

            'should return a 200 response': api.assertStatus 200

.export module
