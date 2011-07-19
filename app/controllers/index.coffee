express = require 'express'

module.exports =

  load: (app) ->

    for controller in ["accounts", "external_accounts", "members", "seed", "transactions", "institutions"]
      (require "./#{controller}").load app
