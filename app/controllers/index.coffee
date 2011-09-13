express = require 'express'

module.exports =

  load: (app) ->

    for controller in ["accounts", "deposits", "external_accounts", "member_accounts", "members", "seed", "session", "documents", "stop_payments", "transactions", "institutions", "transfers"]
      (require "./#{controller}").load app
