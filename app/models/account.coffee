Schema = require('mongoose').Schema

module.exports = new Schema
  _id: String
  member_id: Number
  name: String
  nickname: String
  balance: Number
  available_balance: Number
