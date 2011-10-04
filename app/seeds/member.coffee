Faker = require 'lib/Faker'
async = require 'async'

module.exports =

  createMultiple: (options) =>

    createMember = (callback) ->

      module.exports.create options, (member) ->
        options.onCreate(member, callback)

    async.parallel (createMember for num in [1..options.count]), options.callback

  create: (options, callback) =>

    buildAddress = ->
      street_1: Faker.Address.streetAddress()
      street_2: if (Math.random() < 0.3) then Faker.Address.secondaryAddress()
      city: Faker.Address.city()
      state: Faker.Address.usState(true)
      zip: Faker.Address.zipCode()


    member = new options.models.Member
      _id: options.startingId++
      first_name: Faker.Name.firstName()
      middle_name: Faker.Name.firstName()
      last_name: Faker.Name.lastName()

      phone_list: for type in ['home', 'work', 'mobile']

        phone =
          type: type
          number: Faker.PhoneNumber.phoneNumber()

      mailing_address: buildAddress()
      res_address: buildAddress()
      email_address: Faker.Internet.email()
      mfaQuestion:
        question: "What was your first pet's name?"
        answer: "Fido"
      password: 'password'
      tier_group: "A"

    member.save ->
      callback(member)
