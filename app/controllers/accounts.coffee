module.exports =

  formatter: (account) ->
    output =
      id: account.id
      nickname: account.nickname
      number: account.number

  load: (config) ->

    { Account, Member } = config.models

    formatter = @formatter

    actions =

      index: (req, res) ->

        Account.find { member_id: req.params.member_id }, (err, accounts) ->
          res.send accounts.map(formatter)

      show: (req, res) ->

        Account.findById req.params.id, (err, account) ->
          res.send formatter(account)
