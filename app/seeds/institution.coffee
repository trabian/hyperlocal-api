Faker = require 'lib/Faker'
async = require 'async'
csv = require 'lib/csv'
inflection = require 'lib/inflection'

module.exports =

  createMultiple: (options, callback) =>

    institutions = []

    onData = (data) ->

      routing = 234567890 + +data[0]

      name = data[1].titleize()

      institutions.push new options.models.Institution
        routing_number: routing
        name: name
        address: data[3]
        city: data[4]
        state: data[5]
        zip: data[6]

    createInstitution = (institution, callback) ->
      institution.save callback

    onComplete = =>
      async.forEach institutions, createInstitution, callback

    csv
      .each("fixtures/institutions.csv")
      .addListener('data', onData)
      .addListener('end', onComplete)
