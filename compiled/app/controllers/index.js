(function() {
  module.exports = {
    load: function(app) {
      var AccountsController, MembersController, SeedController;
      AccountsController = require('./accounts').load(app.settings);
      MembersController = require('./members').load(app.settings);
      SeedController = require('./seed').load(app.settings);
      app.get('/members.json', MembersController.index);
      app.get('/members/:id.json', MembersController.show);
      app.get('/members/:member_id/accounts.json', AccountsController.index);
      app.get('/accounts/:id.json', AccountsController.show);
      return app.get('/seed', SeedController.index);
    }
  };
}).call(this);
