express = require 'express'

module.exports =

  load: (app) ->

    for controller in ["accounts", "deposits", "external_accounts", "member_accounts", "members", "seed", "session", "sf_fire_routes", "statements", "stop_payments", "transactions", "institutions", "transfers"]
      (require "./#{controller}").load app
