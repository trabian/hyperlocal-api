vows = require 'vows'
assert = require 'assert'
request = require 'request'

apiUrl = process.env.API_URL
memberNumber = process.env.MEMBER_NUMBER

api = (require './lib/api').load apiUrl, memberNumber

urls = require './helpers/urls'

context =
  topic: ->
    api.authenticate @callback

for url in [urls.actual.accounts.list, urls.actual.externalAccounts.list, urls.actual.payees.list, urls.actual.otherMemberAccounts.list]
  do (url) ->
    context["GET #{url}"] = api.assertStructure url

vows.describe('Top-level API endpoints').addBatch

  # "Urls should be consistent": ->
  #   assert.deepEqual urls.actual, urls.preferred, """
  #     \nWhile not absolutely necessary, for consistency sake it would be nice for the endpoint urls to be:
  #     #{JSON.stringify urls.preferred, null, '  '}
  #     \nThe current urls are:
  #     #{JSON.stringify urls.actual, null, '  '}
  #   """

  '(While logged in)': context

.export module
