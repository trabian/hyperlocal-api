request = require 'request'

auth = {}

module.exports =

  load: (api, apiUrl, memberNumber) ->

    fetch = (method, url, data, callback) ->

      headers =
        Accept: 'application/json'

      if api.auth?.sessionId
        headers.Cookie = "session-id=#{api.auth.sessionId}"

      if api.auth?.clientKey
        headers['x-client-key'] = api.auth.clientKey

      requestData =
        method: method
        url: apiUrl + url || ''
        json: data || {}
        headers: headers

      request requestData, (req, res) ->
        callback null, req, res

      return

    request:

      get: (url, data) ->
        -> fetch 'GET', url, data, @callback

      post: (url, data) ->
        -> fetch  'POST', url, data, @callback

    authenticate: (callback) ->

      fetch 'GET', "/auth/createdevsession/#{memberNumber}", null, (err, req, res) ->

        console.log 'Error', err if err?

        api.auth =
          sessionId: res.body.data.SessionID
          clientKey: res.body.data.ClientKey

        console.log "###\nAuthenticated\n  sessionId: #{api.auth.sessionId}\n  clientKey: #{api.auth.clientKey}\n###\n"

        callback null

      return
