express = require 'express'

module.exports =

  load: (app) ->

    for controller in ["accounts", "external_accounts", "member_accounts", "members", "seed", "transactions", "institutions", "transfers"]
      (require "./#{controller}").load app
