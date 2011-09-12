module.exports =

  load: (app) ->

    app.get '/AccountDetails/accounts', (req, res) ->
      res.redirect "/members/#{app.member_number}/accounts"

    app.get '/estatements/statement/list', (req, res) ->
      res.redirect "/members/#{app.member_number}/documents"

    app.get '/transfers/institutions', (req, res) ->
      res.redirect "/institutions?q=#{req.param('q')}"

    app.get '/transfers/externalaccounts', (req, res) ->
      res.redirect "/members/#{app.member_number}/accounts/external"

    app.get '/transfers/bookmark/list', (req, res) ->
      res.redirect "/members/#{app.member_number}/accounts/member"

    app.get '/billpay/payee/list', (req, res) ->
      res.redirect "/members/#{app.member_number}/accounts/payee"

    app.get '/TransactionHistory/:id', (req, res) ->
      id = [app.member_number, req.params.id].join '-'
      res.redirect "/accounts/#{id}/transactions"

    app.get '/transfers/list', (req, res) ->
      res.redirect "/members/#{app.member_number}/transfers"
