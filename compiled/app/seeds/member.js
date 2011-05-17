(function() {
  var Faker, async;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Faker = require('lib/Faker');
  async = require('async');
  module.exports = {
    createMultiple: __bind(function(options, callback) {
      var createMember, num;
      createMember = function(callback) {
        return module.exports.create(options, function(member) {
          return options.onCreate(member, callback);
        });
      };
      return async.parallel((function() {
        var _ref, _results;
        _results = [];
        for (num = 1, _ref = options.count; 1 <= _ref ? num <= _ref : num >= _ref; 1 <= _ref ? num++ : num--) {
          _results.push(createMember);
        }
        return _results;
      })(), callback);
    }, this),
    create: __bind(function(options, callback) {
      var member;
      member = new options.models.Member({
        _id: options.startingId++,
        first_name: Faker.Name.firstName(),
        middle_name: Faker.Name.firstName(),
        last_name: Faker.Name.lastName(),
        phone: Faker.PhoneNumber.phoneNumber(),
        address: {
          street1: Faker.Address.streetAddress(),
          street2: Math.random() < 0.3 ? Faker.Address.secondaryAddress() : void 0,
          city: Faker.Address.city(),
          state: Faker.Address.usState(true),
          zip: Faker.Address.zipCode()
        }
      });
      return member.save(function() {
        return callback(member);
      });
    }, this)
  };
}).call(this);
