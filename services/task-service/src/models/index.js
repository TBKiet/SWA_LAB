const { Sequelize } = require('sequelize');
const sequelize = require('../config/database');

const db = {
  sequelize,
  Sequelize
};

// Load models
db.Task = require('./Task')(sequelize);

// Run associations if they exist
Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

module.exports = db; 