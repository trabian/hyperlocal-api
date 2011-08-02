async = require 'async'

Schema = require('mongoose').Schema

TransferInstance = new Schema

  transfer_id: String

  created_at:
    type: Date
    default: Date.now

  source_transaction_id: String
  destination_transaction_id: String

module.exports = TransferInstance
