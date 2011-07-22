Schema = require('mongoose').Schema

module.exports = new Schema
  nickname: String
  type: String
  institution: String
  account_number: String
  routing_number: String
  priority: Number
  withdrawable: String
  withdrawable_verification: Array
