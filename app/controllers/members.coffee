
module.exports =

  formatter: (member) ->
    output =
      id: member.id
      first_name: member.first_name
      middle_name: member.middle_name
      last_name: member.last_name
      phone: member.phone
      address: member.address

  load: (config) ->

    { Member } = config.models

    formatter = @formatter

    actions =

      index: (req, res) ->

        Member.find {}, (err, members) ->
          res.send members.map(formatter)

      show: (req, res) ->

        Member.findById req.params.id, (err, member) ->
          res.send formatter(member)
