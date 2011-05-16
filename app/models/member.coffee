Schema = require('mongoose').Schema

module.exports = new Schema
  _id: Number
  first_name: String
  middle_name: String
  last_name: String
  phone: String
  address:
    street1: String
    street2: String
    city: String
    state: String
    zip: String
