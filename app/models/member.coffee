Schema = require('mongoose').Schema

address =
  street_1: String
  street_2: String
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
  custom_account_sort: Array
  mfaQuestion:
    question: String
    answer: String
