format = (object, fields) ->

  output =
    id: object._id

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
      res.send
        data: collection.map formatter
