vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

assertLoanPayment =

  topic: (account) ->
    @callback null, account

  'should include a "due_date" field': (account) ->
    assert.include account, 'due_date'

  'should include an "amount_due" field': (account) ->
    assert.include account, 'amount_due'

assertLoanDetails =

  topic: (account) ->
    @callback null, account

  'should include an "orig_loan_amt" field': (account) ->
    assert.include account, 'orig_loan_amt'

  'should include an "account_opened" field': (account) ->
    assert.include account, 'account_opened'

  'should include a "rate" field': (account) ->
    assert.include account, 'rate'

  'should include a "term" field': (account) ->
    assert.include account, 'term'

vows.describe('Accounts').addBatch

  '(While logged in)':

    topic: ->
      api.authenticate @callback

    '':

      topic: api.request.get urls.accounts.list

      'An account':

        topic: (req, res) ->
          accounts = res.body.data
          @callback null, accounts[0]
          return

        'the account id should be the "short" id': (err, account) ->

          id = account.id

          assert.match id, /^([S,L].*)/, "The short id format without the member number should be returned in the account list. A sample id returned from the API was: #{id}"

        'should have a "urls" hash': (err, account) ->
          assert.include account, 'urls'

        'fetching transactions':

          topic: (account) ->
            api.request.getWithCallback account.urls.transactions, null, @callback
            return

          'should return a 200': api.assertStatus 200

          '(the data)': api.structure.assertDataFormat

      'A loan account':

        topic: (req, res) ->

          accounts = res.body.data

          for account in accounts
            if account.type is 'loan'
              @callback null, account
              return

          @callback "Couldn't find a loan account for this member"
          return

        'loan payment details': assertLoanPayment
        'loan details': assertLoanDetails

      'A mortgage account':

        topic: (req, res) ->

          accounts = res.body.data

          for account in accounts
            if account.type is 'mortgage'
              @callback null, account
              return

          @callback "Couldn't find a mortgage account for this member"
          return

        'loan payment details': assertLoanPayment
        'loan details': assertLoanDetails

      'A line account':

        topic: (req, res) ->

          accounts = res.body.data

          for account in accounts
            if account.type is 'line'
              @callback null, account
              return

          @callback "Couldn't find a line account for this member"

          return

        'should include fields': api.structure.assertFields 'orig_loan_amt', 'available_balance'

.export module
