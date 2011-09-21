vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

assertCheckImage = (side) ->

  topic: (checkUrls) ->
    api.request.getWithCallback checkUrls[side], null, @callback
    return

  'should return a 200 response': api.assertStatus 200

  'should be an image': (err, req, res) ->
    assert.match res.headers['content-type'], /^image\//

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
          @callback null, res.body.data
          return

        "each transfer should have a 'schedule' object": (transfers) ->

          if _.isEmpty transfers
            console.log 'This member did not have any transfers available'
          else
            for transfer in transfers
              assert.include transfer, 'schedule'

        '(a transfer with associated checks)':

          topic: (transfers) ->

            transfer = _.detect transfers, (transfer) -> transfer.urls?.checks?

            if transfer?
              @callback null, transfer.urls.checks
            else
              console.log message = "Couldn't find a transfer with associated checks. Skipping this test."
              @callback null, {}

            return

          'fetching check front': assertCheckImage 'front'
          'fetching check back': assertCheckImage 'back'

      '(a sample transfer)':

        topic: (req, res) ->
          @callback null, res.body.data[0]
          return

        'should have fields:': api.structure.assertFields 'destination_id', 'destination_type', 'urls'

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
                @callback 'External accounts are empty for this member'
              else
                @callback null, accounts, externalAccounts

              return

          'and an external destination':

            topic: (accounts, externalAccounts) ->

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

        'with payee accounts':

          topic: (accounts) ->

            api.request.getWithCallback urls.payees.list, null, (err, req, res) =>

              payees = res.body.data

              if _.isEmpty payees
                @callback "This member doesn't have any payee accounts. Perhaps try a different member?"
              else
                @callback null, accounts, payees

              return

          'and a payee destination':

            topic: (accounts, payeeAccounts) ->

              source = _.detect accounts, (account) ->
                account.billpay_source

              unless source?
                console.log message = "Couldn't find a billpay source"
                @callback message
                return

              destination = payeeAccounts[0]

              transfer =
                amount: 100
                source_id: source.id
                source_type: 'internal'
                destination_id: destination.id
                destination_type: 'payee'
                schedule:
                  type: 'later'
                  start_at: destination.minimum_next_payment_date

                transfer_type: 'billpay'

              api.request.postWithCallback urls.transfers.create, transfer, @callback

              return

            'should return a 200 response': api.assertStatus 200

            '(the new transfer)':

              topic: (req, res) ->
                @callback null, res.body.data
                return

              'should include fields:': api.structure.assertFields 'urls'

.export module
