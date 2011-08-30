express = require 'express'

module.exports =

  load: (app) ->

    for controller in ["accounts", "external_accounts", "member_accounts", "members", "seed", "session", "statements", "stop_payments", "transactions", "institutions", "transfers"]
      (require "./#{controller}").load app
