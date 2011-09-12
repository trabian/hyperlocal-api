format = (object, fields, mapId = true) ->

  output = {}

  output.id = object._id if mapId

  for field in fields
    output[field] = object[field]

  output

module.exports =

  format: format

  send: (res, object, options) =>

    formatter = options.formatter ? (object) ->
      format object, options.fields

    if err = options.err?
      res.send err
    else
      res.send
        data: if object then formatter(object) else {}

  sendCollection: (res, collection, options) =>

    formatter = options.formatter ? (object) ->
      format object, options.fields

    if err = options.err?
      res.send err

    else

      out =
        data: collection.map formatter

      if options.pageData?
        out.page = options.pageData

      res.send out
