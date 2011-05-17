(function() {
  var Faker, async;
  Faker = require('lib/Faker');
  async = require('async');
  module.exports = {
    load: function(settings) {
      var Account, Member, accountSeed, actions, memberSeed, mongoose, _ref;
      _ref = settings.models, Account = _ref.Account, Member = _ref.Member;
      mongoose = settings.mongoose;
      memberSeed = require('../seeds/member');
      accountSeed = require('../seeds/account');
      return actions = {
        index: function(req, res) {
          var count, dropCollection, startTime;
          count = req.param('count');
          startTime = new Date().getTime();
          dropCollection = function(collection, callback) {
            return collection.remove({}, callback);
          };
          return async.forEach([Member, Account], dropCollection, function(err) {
            var memberOptions;
            if (err) {
              return console.log(err);
            } else {
              memberOptions = {
                startingId: 123001,
                models: settings.models,
                count: count,
                onCreate: function(member, callback) {
                  var accountOptions;
                  accountOptions = {
                    member: member,
                    models: settings.models
                  };
                  return accountSeed.createMultiple(accountOptions, callback);
                }
              };
              return memberSeed.createMultiple(memberOptions, function() {
                var duration;
                duration = new Date().getTime() - startTime;
                return res.send("Created " + count + " members in " + duration + " milliseconds");
              });
            }
          });
        }
      };
    }
  };
}).call(this);
