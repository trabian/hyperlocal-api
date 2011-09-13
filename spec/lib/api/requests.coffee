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

      delete: (url, data) ->
        -> fetch  'POST', url, data, @callback

      getWithCallback: (url, data, callback) ->
        fetch  'GET', url, data, callback

      postWithCallback: (url, data, callback) ->
        fetch  'POST', url, data, callback

      deleteWithCallback: (url, data, callback) ->
        fetch  'DELETE', url, data, callback

    authenticate: (callback) ->

      test_mode = process.env.TEST_MODE or 1

      fetch 'GET', "/auth/createdevsession/#{memberNumber}?test_mode=#{test_mode}", null, (err, req, res) ->

        unless res.body.data?
          console.log 'Response body', res.body

        if data = res.body.data
          auth.sessionId = data.session_id or data.SessionID
          auth.clientKey = data.client_key or data.ClientKey

          callback null, data

        else
          callback 'Login unsuccessful'

      return
