Schema = require('mongoose').Schema

PayeeAccount = new Schema
  name: String
  member_id: Number
  nickname: String
  account_number: String
  address_1: String
  address_2: String
  city: String
  state: String
  zip_code: String
  phone: String
  payee_notes: String
  payee_category: String
  status: String
  minimum_next_payment_date:
    type: Date
    default: Date.now
  last_payment_date:
    type: Date
    default: Date.now
  created_date:
    type: Date
    default: Date.now

PayeeAccount.virtual('url').get ->
  "/accounts/payee/#{@id}"

module.exports = PayeeAccount
