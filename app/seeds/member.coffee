Faker = require 'lib/Faker'
async = require 'async'

module.exports =

  createMultiple: (options, callback) =>

    createMember = (callback) ->

      module.exports.create options, (member) ->
        options.onCreate(member, callback)

    async.parallel (createMember for num in [1..options.count]), callback

  create: (options, callback) =>

    member = new options.models.Member
      _id: options.startingId++
      first_name: Faker.Name.firstName()
      middle_name: Faker.Name.firstName()
      last_name: Faker.Name.lastName()
      phone: Faker.PhoneNumber.phoneNumber()
      address:
        street1: Faker.Address.streetAddress()
        street2: if (Math.random() < 0.3) then Faker.Address.secondaryAddress()
        city: Faker.Address.city()
        state: Faker.Address.usState(true)
        zip: Faker.Address.zipCode()

    member.save ->
      callback(member)
