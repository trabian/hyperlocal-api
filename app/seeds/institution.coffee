Faker = require 'lib/Faker'
async = require 'async'
csv = require 'lib/csv'

module.exports =

  createMultiple: (options, callback) =>

    institutions = []

    onData = (data) ->

      routing = 234567890 + +data[0]

      institutions.push new options.models.Institution
        routing_number: routing
        name: data[1]
        address: data[2]
        city: data[3]
        state: data[4]
        zip: data[5]

    createInstitution = (institution, callback) ->
      institution.save callback

    onComplete = =>
      async.forEach institutions, createInstitution, callback

    csv
      .each("fixtures/institutions.csv")
      .addListener('data', onData)
      .addListener('end', onComplete)
