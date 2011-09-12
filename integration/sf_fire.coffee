routes =

  accounts:
    pattern: /^\/AccountDetails\/accounts/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/accounts"

  externalAccounts:
    pattern: /^\/transfers\/externalaccounts/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/accounts/external"

  externalAccount:
    pattern: /^\/transfers\/externalaccount/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/accounts/external"

  memberAccounts:
    pattern: /^\/transfers\/bookmark\/list/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/accounts/member"

  payeeAccounts:
    pattern: /^\/billpay\/payee\/list/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/accounts/payee"

  estatements:
    pattern: /^\/estatements\/statement\/list/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/documents"

  institutions:
    pattern: /^\/transfers\/institutions/
    rewrite: (req, res) ->
      "/institutions"

  transactions:
    pattern: /^\/TransactionHistory\/(.*)/
    rewrite: (req, res, match) ->
      "/accounts/#{match[1]}/transactions"

  transfers:
    pattern: /^\/transfers\/list/
    rewrite: (req, res) ->
      "/members/#{req.app.member_number}/transfers"

module.exports =

  middleware: (req, res, next) ->

    for name, route of routes
      if match = req.url.match route.pattern
        req.url = route.rewrite req, res, match

    do next
