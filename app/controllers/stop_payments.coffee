{ ResponseHelper } = require 'app/helpers'

async = require 'async'
_ = require 'underscore'

module.exports =

  fields: ["start", "end", "created_at"]

  load: (app) ->

    { StopPayment } = app.settings.models

    fields = module.exports.fields

    app.post '/accounts/:account_id/stop_payments', (req, res) ->

      data = req.body

      stopPayment = new StopPayment
        account_id: req.params.account_id
        start: data.start
        end: data.end

      stopPayment.save (err, doc) =>
        ResponseHelper.send res, doc, { fields, err }

    app.get '/accounts/:account_id/stop_payments', (req, res) ->

      StopPayment.find(account_id: req.params.account_id)
                 .sort('created_at', -1)
                 .execFind (err, stopPayments) ->

          ResponseHelper.sendCollection res, stopPayments, { fields, err }
