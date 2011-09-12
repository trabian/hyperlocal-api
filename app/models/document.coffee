Schema = require('mongoose').Schema

Document = new Schema

  member_id: Number

  name: String

  created_at:
    type: Date
    default: Date.now

Document.virtual('url').get -> "/documents/#{@id}.pdf"

Document.virtual('description').get -> @name

Document.virtual('date').get -> @created_at

module.exports = Document
