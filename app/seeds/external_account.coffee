async = require 'async'

module.exports =

  # Really just one for now
  createMultiple: (options) =>

    externalAccount = new options.models.ExternalAccount
      member_id: options.member.id
      nickname: "Test Account"
      institution: "Fake Credit Union"
      account_number: "1234"
      routing_number: "4321"

    externalAccount.save options.callback
