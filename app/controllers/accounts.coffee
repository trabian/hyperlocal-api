module.exports =

  formatter: (account) ->
    output =
      id: account._id
      name: account.name
      nickname: account.nickname
      balance: account.balance
      available_balance: account.available_balance

  load: (settings) ->

    { Account, Member } = settings.models

    formatter = @formatter

    actions =

      index: (req, res) ->

        Account.find { member_id: req.params.member_id }, (err, accounts) ->
          res.send
            data: accounts.map(formatter)

      show: (req, res) ->

        Account.findById req.params.id, (err, account) ->
          res.send
            data: formatter(account)
