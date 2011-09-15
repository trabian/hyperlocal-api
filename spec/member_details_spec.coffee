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

      'should include phone_list as an array': (member) ->
        assert.isArray member.phone_list

      'Adding an account sort order':

        topic: (member) ->

          sortArray = ['test1', 'test2']

          api.request.postWithCallback urls.memberDetails.updateAccountSort, data: sortArray, (err, req, res) =>
            @callback err, req, res, sortArray, member

        'should return a 200': api.assertStatus 200

        '(the member details)':

          topic: (req, res, sortArray, member) ->

            api.request.getWithCallback urls.memberDetails.detail, null, (err, req, res) =>
              @callback null, res.body.data, sortArray

            return

          'should include the new sort array': (err, details, sortArray) ->
            assert.deepEqual details.custom_account_sort, sortArray

.export module
