const { Sequelize, DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
require('dotenv').config();

const sequelize = new Sequelize({
  dialect: 'postgres',
  database: process.env.DATABASE,
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  dialectOptions: {
      ssl: {
          rejectUnauthorized: true,
          ca: process.env.CA
      }
  }
});

const User = sequelize.define('User', {
  username: { type: DataTypes.STRING, allowNull: false, unique: true },
  email: { type: DataTypes.STRING, allowNull: false, unique: true },
  password: { type: DataTypes.STRING, allowNull: false }
}, {
  tableName: 'User'
});

// Hash the password before saving
User.beforeCreate(async (user) => {
  const hashedPassword = await bcrypt.hash(user.password, 10);
  user.password = hashedPassword;
});

// Method to compare password for login
User.prototype.comparePassword = async function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

const DiaryEntry = sequelize.define('DiaryEntry', {
  id: { 
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
  },
  title: { 
      type: DataTypes.STRING, 
      allowNull: false 
  },
  description: { 
      type: DataTypes.TEXT, 
      allowNull: false 
  },
  date: { 
      type: DataTypes.DATEONLY, // Store only the date
      defaultValue: Sequelize.NOW 
  },
  location: { 
      type: DataTypes.STRING 
  },
  userId: { 
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
          model: 'User',
          key: 'id'
      }
  }
}, {
  tableName: 'DiaryEntry'
});

// Define association
DiaryEntry.belongsTo(User, { foreignKey: 'userId' });

module.exports = { User, DiaryEntry };
