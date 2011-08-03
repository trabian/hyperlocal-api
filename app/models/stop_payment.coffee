Schema = require('mongoose').Schema

module.exports = new Schema
  start: String
  end: String

  created_at:
    type: Date
    default: Date.now

  account_id: String
