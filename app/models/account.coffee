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
  rate: Number
  term: Number
  original_amount: Number
  original_date: Date
  payment_amount: Number
  next_payment_date: Date
