(function() {
  var express;
  require.paths.unshift('.');
  require.paths.unshift('./node_modules');
  express = require('express');
  exports.boot = function(next) {
    var app, boundServices, credentials;
    app = express.createServer();
    boundServices = process.env.VCAP_SERVICES ? JSON.parse(process.env.VCAP_SERVICES) : null;
    if (boundServices) {
      credentials = boundServices['mongodb-1.8'][0]['credentials'];
      app.set('database', "mongodb://" + credentials.username + ":" + credentials.password + "@" + credentials.hostname + ":" + credentials.port + "/" + credentials.db);
    } else {
      app.set('database', 'mongodb://localhost/hyperlocal_api');
    }
    app.set('port', 3001);
    require('app/models').load(app.settings);
    require('app/controllers').load(app);
    return next(app);
  };
  if (!module.parent) {
    exports.boot(function(app) {
      var port;
      port = process.env.VMC_APP_PORT || app.set('port');
      console.log("Started API server on port " + port + " using db: " + (app.set('database')) + ". You can access it at http://localhost:" + port + "/members.json");
      app.listen(port);
      return app;
    });
  }
}).call(this);
