Schema = require('mongoose').Schema

module.exports = new Schema
  _id: String
  member_id: Number
  name: String
  nickname: String
  type: String
  balance: Number
  available_balance: Number
  priority: Number
  checking: Boolean
