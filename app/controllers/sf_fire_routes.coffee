module.exports =

  load: (app) ->

    app.get '/AccountDetails/accounts', (req, res) ->
      res.redirect "/members/#{app.member_number}/accounts"
