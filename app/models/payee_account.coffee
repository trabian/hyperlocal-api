Schema = require('mongoose').Schema

address = require 'app/models/extensions/address'

PayeeAccount = new Schema
  name: String
  member_id: Number
  nickname: String
  account_number: String
  address: address
  phone: String
  payee_notes: String
  payee_category: String
  type:
    type: String
    default: 'payee'
  payee_type:
    type: String
    default: 'check'
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

PayeeAccount.virtual('urls').get ->

  base = "/accounts/payee/#{@id}"

  detail: base
  history: "#{base}/transfers"

module.exports = PayeeAccount
