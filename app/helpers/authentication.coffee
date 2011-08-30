module.exports =

  middleware: (req, res, next) ->

    if req.session.login?.client_key?
      do next
    else
      res.writeHead 403
      res.end()
