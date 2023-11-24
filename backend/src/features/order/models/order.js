const { Model, DataTypes } = require('sequelize');

const { sequelize } = require('../../../configs/db');

class Order extends Model { }

Order.init({
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
    unique: {
      args: true,
      msg: 'ID order telah diambil!',
    },
    allowNull: false,
    validate: {
      notNull: {
        msg: 'ID order tidak boleh kosong!',
      },
    },
  },
  user_uid: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'Masukkan UID user!',
      },
    },
  },
  device_type_id: {
    type: DataTypes.UUID,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'ID order tidak boleh kosong!',
      },
    },
    references: { model: 'device_types', key: 'id' },
    onUpdate: 'CASCADE',
    onDelete: 'CASCADE',
  },
  complains: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  status: {
    type: DataTypes.ENUM('Sedang dalam antrian', 'Sedang diperbaiki', 'Selesai'),
    allowNull: false,
    defaultValue: 'Sedang dalam antrian',
    validate: {
      notNull: {
        msg: 'Status perbaikan tidak boleh kosong!',
      },
      isIn: {
        args: [['Sedang dalam antrian', 'Sedang diperbaiki', 'Selesai']],
        msg: 'Status perbaikan tidak valid!',
      },
    },
  },
  response_midtrans: {
    type: DataTypes.TEXT('long'),
    allowNull: true,
  },
  status_transaksi: {
    type: DataTypes.ENUM('Belum dibayar', 'Diproses', 'Berhasil', 'Gagal'),
    allowNull: false,
    defaultValue: 'Belum dibayar',
    validate: {
      notNull: {
        msg: 'Status transaksi tidak boleh kosong!',
      },
      isIn: {
        args: [['Belum dibayar', 'Diproses', 'Berhasil', 'Gagal']],
        msg: 'Status transaksi tidak valid!',
      },
    },
  },
}, {
  sequelize,
  underscored: true,
  timestamps: true,
  modelName: 'Order',
  indexes: [
    {
      unique: true,
      fields: ['id'],
    },
  ],
});

module.exports = Order;
