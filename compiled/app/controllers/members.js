(function() {
  module.exports = {
    formatter: function(member) {
      var output;
      return output = {
        id: member.id,
        first_name: member.first_name,
        middle_name: member.middle_name,
        last_name: member.last_name,
        phone: member.phone,
        address: member.address
      };
    },
    load: function(settings) {
      var Member, actions, formatter;
      Member = settings.models.Member;
      formatter = this.formatter;
      return actions = {
        index: function(req, res) {
          return Member.find({}, function(err, members) {
            if (err) {
              return console.log(err);
            } else {
              return res.send(members.map(formatter));
            }
          });
        },
        show: function(req, res) {
          return Member.findById(req.params.id, function(err, member) {
            if (err) {
              return console.log(err);
            } else {
              return res.send(formatter(member));
            }
          });
        }
      };
    }
  };
}).call(this);
