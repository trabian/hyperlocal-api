Schema = require('mongoose').Schema

Account = new Schema
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
  amount_due: Number
  due_date: Date

Account.virtual('urls').get ->
  transactions: "/accounts/#{@id}/transactions"

module.exports = Account
