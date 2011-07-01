express = require 'express'

module.exports =

  load: (app) ->

    for controller in ["accounts", "members", "seed", "transactions"]
      (require "./#{controller}").load app
