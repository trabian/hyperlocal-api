async = require 'async'

{ RandomHelper } = require 'app/helpers'

module.exports = class TransactionSeed

  constructor: (@options) ->

  createManyForDay: (date, callback) =>

    transactionsToCreate = RandomHelper.inRange 0, 10

    create = async.apply @create, date

    async.forEach [0..transactionsToCreate], create, callback 

