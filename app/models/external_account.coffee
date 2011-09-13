Schema = require('mongoose').Schema

ExternalAccount = new Schema
  nickname: String
  type: String
  name: String
  account_owner_name: String
  account_number: String
  account_class: String
  account_permission: String
  routing_number: String
  priority: Number
  withdrawable: String
  withdrawable_verification: Array
  deleted: Boolean
  verified:
    type: Boolean
    default: false

ExternalAccount.virtual('url').get ->
  "/accounts/external/#{@id}"

module.exports = ExternalAccount
