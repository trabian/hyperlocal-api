async = require 'async'

module.exports =

  createMultiple: (options) =>

    names = ["eStatement", "VISA Statement"]

    postDates = for monthsAgo in [options.monthsToCreate..0]
      date = new Date()
      date.setMonth date.getMonth() - monthsAgo
      date

    create = (date, callback) =>

      createForName = (name, callback) =>

        document = new options.models.Document
          member_id: options.member.id
          name: name
          created_at: date

        document.save callback

      async.forEachSeries names, createForName, callback

    async.forEachSeries postDates, create, options.callback
