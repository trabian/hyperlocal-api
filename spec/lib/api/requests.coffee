request = require 'request'

auth = {}

module.exports =

  load: (apiUrl, memberNumber) ->

    fetch = (method, url, data, callback) ->

      headers =
        Accept: 'application/json'

      if data
        headers['Content-Type'] = 'application/json'

      if sessionId = auth.sessionId
        headers.Cookie = "session-id=#{sessionId}"

      if clientKey = auth.clientKey
        headers['x-client-key'] = clientKey

      requestData =
        method: method
        url: apiUrl + url || ''
        json: data || {}
        headers: headers

      request requestData, (req, res) ->
        callback null, req, res

      return

    request:

      fetch: fetch

      get: (url, data) ->
        -> fetch 'GET', url, data, @callback

      post: (url, data) ->
        -> fetch  'POST', url, data, @callback

      getWithCallback: (url, data, callback) ->
        fetch  'GET', url, data, callback

      postWithCallback: (url, data, callback) ->
        fetch  'POST', url, data, callback

    authenticate: (callback) ->

      test = process.env.TEST isnt 'false'

      fetch 'GET', "/auth/createdevsession/#{memberNumber}#{if test then '?test_mode=1'}", null, (err, req, res) ->

        unless res.body.data?
          console.log 'Response body', res.body

        auth.sessionId = res.body.data.SessionID
        auth.clientKey = res.body.data.ClientKey

        console.log "###\nAuthenticated\n  sessionId: #{auth.sessionId}\n  clientKey: #{auth.clientKey}\n###\n"

        callback null

      return
