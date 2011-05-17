(function() {
  var Account, Faker, Member, accountSeed, async, config, memberSeed, membersToCreate, mongoose, timer, _, _ref;
  require.paths.unshift('.');
  Faker = require('./lib/Faker');
  async = require('async');
  _ = require('underscore');
  config = {
    database: 'mongodb://localhost/hyperlocal_api'
  };
  require('app/models').load(config);
  _ref = config.models, Account = _ref.Account, Member = _ref.Member;
  mongoose = config.mongoose;
  membersToCreate = 5;
  timer = "create " + membersToCreate + " members";
  console.time(timer);
  memberSeed = require('./seeds/member');
  accountSeed = require('./seeds/account');
  mongoose.connection.db.dropDatabase(function() {
    var memberOptions;
    memberOptions = {
      startingId: 123001,
      models: config.models,
      count: membersToCreate,
      onCreate: function(member, callback) {
        var accountOptions;
        accountOptions = {
          member: member,
          models: config.models
        };
        return accountSeed.createMultiple(accountOptions, callback);
      }
    };
    return memberSeed.createMultiple(memberOptions, function() {
      console.timeEnd(timer);
      return mongoose.connection.close();
    });
  });
}).call(this);
