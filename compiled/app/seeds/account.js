(function() {
  var Faker, async, randomNumberInRange, _;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Faker = require('lib/Faker');
  async = require('async');
  _ = require('underscore');
  randomNumberInRange = function(lower, upper) {
    return lower + Math.random() * (upper - lower);
  };
  module.exports = {
    createMultiple: __bind(function(options, callback) {
      var accountCount, createAccount, num, samples, startingAccount;
      samples = _.values(module.exports.samples);
      startingAccount = 0;
      accountCount = 1 + Math.floor(Math.random() * samples.length);
      createAccount = function(accountCallback) {
        options.sample = samples[startingAccount++];
        return module.exports.create(options, function(account) {
          return accountCallback();
        });
      };
      return async.parallel((function() {
        var _results;
        _results = [];
        for (num = 1; 1 <= accountCount ? num <= accountCount : num >= accountCount; 1 <= accountCount ? num++ : num--) {
          _results.push(createAccount);
        }
        return _results;
      })(), callback);
    }, this),
    create: __bind(function(options, callback) {
      var account, availableBalance, balance, id, member, sample;
      member = options.member, sample = options.sample;
      id = "" + member._id + "-" + options.sample.suffix;
      balance = randomNumberInRange(options.sample.min, options.sample.max).toFixed(2);
      availableBalance = 0;
      if (options.sample.type === 'share') {
        availableBalance = (balance - randomNumberInRange(0, 300)).toFixed(2);
      } else {
        availableBalance = (balance - options.sample.min).toFixed(2);
      }
      account = new options.models.Account({
        _id: id,
        member_id: member._id,
        name: options.sample.name,
        balance: balance,
        available_balance: availableBalance
      });
      if (Math.random() < 0.5) {
        account.nickname = "My " + options.sample.name + " Account";
      }
      return account.save(callback);
    }, this),
    samples: {
      "share_savings": {
        name: "Share Savings",
        min: 5.0,
        max: 3500.0,
        suffix: "S1",
        type: "share"
      },
      "checking": {
        name: "Checking",
        min: 200.0,
        max: 15000.0,
        suffix: "S10",
        type: "share"
      },
      "auto": {
        name: "Auto Loan",
        min: -10000.0,
        max: -500.0,
        suffix: "S10",
        type: "loan"
      },
      "heloc": {
        name: "Home Equity Line of Credit",
        min: -40000.0,
        max: -500.0,
        suffix: "L21",
        type: "loan"
      }
    }
  };
}).call(this);
