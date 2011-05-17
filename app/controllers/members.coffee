module.exports =

  formatter: (member) ->
    output =
      id: member.id
      first_name: member.first_name
      middle_name: member.middle_name
      last_name: member.last_name
      phone: member.phone
      address: member.address

  load: (settings) ->

    { Member } = settings.models

    formatter = @formatter

    actions =

      index: (req, res) ->

        Member.find {}, (err, members) ->
          if err
            console.log err
          else
            res.send members.map(formatter)

      show: (req, res) ->

        Member.findById req.params.id, (err, member) ->
          if err
            console.log err
          else
            res.send formatter(member)
