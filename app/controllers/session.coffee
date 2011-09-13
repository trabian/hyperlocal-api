path = require 'path'
fs = require 'fs'
_ = require 'underscore'

{ Authentication, ResponseHelper } = require 'app/helpers'

auth = Authentication.middleware

MemberController = require 'app/controllers/members'

module.exports =

  load: (app) ->

    { Account, Member } = app.settings.models

    app.get '/session/ping.json', auth, (req, res) ->
      res.writeHead 200
      res.end()

    app.get '/session.json', (req, res) ->

      req.session.login ||=
        state: 'member_number'
        created_at: new Date()

      res.send
        data: req.session.login

    app.get '/auth/createdevsession/:member_number', (req, res) ->

      app.member_number = req.params.member_number

      Member.findById app.member_number, (err, member) ->

        res.send
          data:
            session_id: '1234'
            client_key: '4321'
            member_number: app.member_number
            member_details: ResponseHelper.format member, MemberController.fields

    app.get '/session/security_phrase.png', (req, res) ->

      checkFile = path.join process.cwd(), "fixtures/security_phrase.png"

      fs.readFile checkFile, "binary", (err, file) ->
        res.writeHead 200
        res.write file, "binary"
        res.end()

    app.post '/session.json', (req, res) ->

      member_id_in_session = req.session?.member_id

      responded = false

      if member_id = req.body.session.member_id

        Member.findById member_id, (err, member) ->

          if member?

            if (member_id isnt req.session?.login?.member_id) or (member.get 'state') is 'member_number'

              console.log 'not member id?'

              _.extend req.session.login,
                state: 'mfa'
                member_id: member_id
                mfa_question: member.mfaQuestion?.question

            else

              switch req.session.login.state
                when 'mfa'

                  if (answer = req.body.session.mfa_answer) and answer is member.mfaQuestion.answer

                    _.extend req.session.login,
                      state: 'password'
                      member_id: member_id
                      mfa_question: null

                when 'password'

                  if (password = req.body.session.password) and password is member.password

                    responded = true

                    _.extend req.session.login,
                      client_key: (new Date()).getTime()

                    res.send
                      data:
                        state: 'complete'
                        client_key: req.session.login.client_key

          else

            _.extend req.session.login,
              state: 'member_number'
              member_id: member_id
              mfa_question: null

          unless responded
            res.send
              data: req.session.login

      else

        res.send
          data: req.session.login
