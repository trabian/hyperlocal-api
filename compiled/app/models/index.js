(function() {
  var mongoose, _;
  mongoose = require('mongoose');
  _ = require('underscore');
  exports.load = function(settings) {
    var models;
    settings.mongoose = mongoose;
    mongoose.connect(settings.database);
    models = {};
    _.each(['Account', 'Member'], function(name) {
      return models[name] = mongoose.model(name, require("./" + (name.toLowerCase())));
    });
    return settings.models = models;
  };
}).call(this);
