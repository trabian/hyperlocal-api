module.exports =

  inRange: (lower, upper) ->
    lower + Math.random() * (upper - lower)

  inArray: (array) ->
    array[Math.floor(Math.random() * array.length)]
