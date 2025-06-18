const { Sequelize } = require('sequelize');

const defaultConfig = {
  dialect: 'postgres',
  logging: false,
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
};

const sequelize = process.env.DATABASE_URL
  ? new Sequelize(process.env.DATABASE_URL, defaultConfig)
  : new Sequelize(
      process.env.DB_NAME || 'todo_db',
      process.env.DB_USER || 'postgres',
      process.env.DB_PASSWORD || 'postgres',
      {
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        ...defaultConfig
      }
    );

module.exports = sequelize; 