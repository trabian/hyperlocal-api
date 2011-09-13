Schema = require('mongoose').Schema

address =
  street1: String
  street2: String
  city: String
  state: String
  zip: String

module.exports = new Schema
  _id: Number
  first_name: String
  middle_name: String
  last_name: String
  phone_list: Array
  password: String
  res_address: address
  alt_address: address
  mfaQuestion:
    question: String
    answer: String
