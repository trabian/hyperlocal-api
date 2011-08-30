module.exports =

  middleware: (req, res, next) ->

    if req.app.set 'authenticate'

      if "#{req.session.login?.client_key}" == req.headers['x-client-key']
        do next
      else
        res.writeHead 403
        res.end()

    else
      do next
