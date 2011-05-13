module.exports =

  load: (config) ->

    controllers =

      MembersController: require('./members').load(config)
