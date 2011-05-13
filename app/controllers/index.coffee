module.exports =

  load: (config) ->

    controllers =

      AccountsController: require('./accounts').load(config)
      MembersController: require('./members').load(config)
