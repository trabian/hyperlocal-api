Schema = require('mongoose').Schema

address = require 'app/models/extensions/address'

creditMatrix =
  "a+": "800 (+)"
  "a": "760-799"
  "a-": "720-759"
  "b+": "700-719"
  "b": "680-699"
  "b-": "660-679"
  "c+": "650-659"
  "c": "640-649"
  "c-": "630-639"
  "d+": "620-629"
  "d": "610-619"
  "d-": "600-609"
  "e+": "560-599"
  "e": "520-559"
  "e-": "480-519"
  "f": "479"

Member = new Schema
  _id: Number
  first_name: String
  middle_name: String
  last_name: String
  phone_list: Array
  password: String
  email_address: String
  res_address: address
  mailing_address: address
  custom_account_sort: Array
  mfaQuestion:
    question: String
    answer: String
  last_login:
    type: Date
    default: Date.now
  tier_group: String
  tier_group_last_updated:
    type: Date
    default: Date.now

Member.static 'creditMatrix', (callback) ->
  callback creditMatrix

Member.virtual('tier_group_range').get -> creditMatrix[@tier_group.toLowerCase()] 

module.exports = Member
