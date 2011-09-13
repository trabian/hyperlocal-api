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
  term: String
  orig_loan_amt: Number
  account_opened: Date
  maturity_date: Date
  amount_due: Number
  due_date: Date
  limit: Number

Account.virtual('urls').get ->
  transactions: "/accounts/#{@id}/transactions"

module.exports = Account
