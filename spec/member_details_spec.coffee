vows = require 'vows'
assert = require 'assert'
_ = require 'underscore'

api = require './lib/api'

urls = api.urls.actual

sampleMember =
  email_address: 'contact@sffirecu.org'
  res_address:
    street_1: "555 Test St"
    street_2: "Apt 103"
    city: 'San Francisco'
    state: 'CA'
    zip: '94118'
    country: ''

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

      'should include fields:': api.structure.assertFields 'email_address', 'first_name', 'middle_name', 'last_name', 'phone_list', 'res_address'

      'should have a res_address': api.structure.assertAddress 'res_address'

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

      'Updating contact information':

        topic: (member) ->

          api.request.postWithCallback urls.memberDetails.update, sampleMember, (err, req, res) =>
            @callback err, req, res, member, sampleMember

        'should return a 200': api.assertStatus 200

        '(the member details)':

          topic: (req, res, member, sampleMember) ->

            api.request.getWithCallback urls.memberDetails.detail, null, (err, req, res) =>
              @callback null, sampleMember, res.body.data

            return

          'should include the updated residential address': (err, sampleMember, updatedMember) ->
            assert.deepEqual updatedMember.res_address, sampleMember.res_address

          'should include the updated email address': (err, sampleMember, updatedMember) ->
            assert.deepEqual updatedMember.email, sampleMember.email

.export module
