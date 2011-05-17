(function() {
  module.exports = {
    formatter: function(account) {
      var output;
      return output = {
        id: account._id,
        name: account.name,
        nickname: account.nickname,
        balance: account.balance,
        available_balance: account.available_balance
      };
    },
    load: function(settings) {
      var Account, Member, actions, formatter, _ref;
      _ref = settings.models, Account = _ref.Account, Member = _ref.Member;
      formatter = this.formatter;
      return actions = {
        index: function(req, res) {
          return Account.find({
            member_id: req.params.member_id
          }, function(err, accounts) {
            return res.send(accounts.map(formatter));
          });
        },
        show: function(req, res) {
          return Account.findById(req.params.id, function(err, account) {
            return res.send(formatter(account));
          });
        }
      };
    }
  };
}).call(this);
