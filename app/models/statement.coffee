Schema = require('mongoose').Schema

module.exports = new Schema

  member_id: Number

  name: String

  created_at:
    type: Date
    default: Date.now
