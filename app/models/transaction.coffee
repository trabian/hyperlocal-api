Schema = require('mongoose').Schema

module.exports = new Schema
  account_id: String
  account_type: String
  name: String
  nickname: String
  amount: Number
  balance: Number
  posted_at: Date
  type: String
  pending: Boolean
  category: String
  dividend_rate: Number
  dividend_balance: Number
  check_number: Number
  note: String
  transfer_instance_id: String
