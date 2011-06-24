Schema = require('mongoose').Schema

module.exports = new Schema
  _id: String
  account_id: String
  name: String
  nickname: String
  amount: Number
  posted_at: Date
  type: String
