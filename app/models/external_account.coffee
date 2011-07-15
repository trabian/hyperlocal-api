Schema = require('mongoose').Schema

module.exports = new Schema
  _id: String
  nickname: String
  type: String
  institution: String
  account_number: String
  routing_number: String
  priority: Number
