module.exports =

  inRange: (lower, upper) ->
    lower + Math.random() * (upper - lower)

  amountInRange: (lower, upper) ->
    module.exports.inRange(lower, upper).toFixed(2)

  inArray: (array) ->
    array[Math.floor(Math.random() * array.length)]

  timeInDay: (date) ->

    inRange = module.exports.inRange

    date = new Date date

    date.setHours inRange(0, 24)
    date.setMinutes inRange(0, 60)
    date.setSeconds inRange(0, 60)

    date
