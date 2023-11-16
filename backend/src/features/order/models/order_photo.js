const { Model, DataTypes } = require('sequelize');

const { sequelize } = require('../../../configs/db');

class OrderPhoto extends Model { }

OrderPhoto.init({
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
    unique: {
      args: true,
      msg: 'ID OrderPhoto telah diambil!',
    },
    allowNull: false,
    validate: {
      notNull: {
        msg: 'ID OrderPhoto tidak boleh kosong!',
      },
    },
  },
  order_id: {
    type: DataTypes.UUID,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'ID Order tidak boleh kosong!',
      },
    },
    references: { model: 'orders', key: 'id' },
    onUpdate: 'CASCADE',
    onDelete: 'CASCADE',
  },
  photo_path: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'Masukkan filepath dari foto order!',
      },
    },
  },
  photo_url: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'Masukkan url dari foto order!',
      },
    },
  },
}, {
  sequelize,
  underscored: true,
  timestamps: true,
  modelName: 'OrderPhoto',
  indexes: [
    {
      unique: true,
      fields: ['id'],
    },
  ],
});

module.exports = OrderPhoto;
