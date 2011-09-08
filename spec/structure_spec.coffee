vows = require 'vows'
assert = require 'assert'

api = require './lib/api'

urls = api.urls.actual

context =
  topic: ->
    api.authenticate @callback

for url in [urls.accounts.list, urls.externalAccounts.list, urls.payees.list, urls.otherMemberAccounts.list]
  do (url) ->
    context["GET #{url}"] = api.structure.assert url

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
