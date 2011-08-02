Schema = require('mongoose').Schema

Institution = new Schema
  name:
    type: String
    index: true
  routing_number:
    type: String
    index: true
  address: String
  city: String
  state: String
  zip:
    type: String
    index: true

Institution.static 'search', (query, callback) ->

  orQuery = $or: [
    { 'routing_number': query },
    {
      'name': new RegExp query, 'i'
    },
    { 'zip': query }
  ]

  @find orQuery, callback

module.exports = Institution
