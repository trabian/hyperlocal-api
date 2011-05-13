class XhrBasicAuthFix

  def initialize(app)
    @app = app
  end

  def call(env)

    status, headers, response = @app.call(env)

    if status == 401
      status = 403
      headers.delete "WWW-Authenticate"
      headers["Proxy-Original-Status"] = "401"
    end

    [status, headers, response]

  end

end
