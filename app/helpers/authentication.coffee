module.exports =

  middleware: (req, res, next) ->

    clientKeyHeader = req.headers['x-client-key']

    console.log 'header', clientKeyHeader, req.session.login?.client_key

    if "#{req.session.login?.client_key}" == req.headers['x-client-key']
      do next
    else
      res.writeHead 403
      res.end()
