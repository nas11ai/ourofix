const DataTypes = require('sequelize');

module.exports = {
  up: async ({ context: queryInterface }) => {
    await queryInterface.createTable('users', {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        unique: {
          args: true,
          msg: 'ID user telah diambil!',
        },
        allowNull: false,
        validate: {
          notNull: {
            msg: 'ID user tidak boleh kosong!',
          },
        },
      },
      username: {
        type: DataTypes.STRING,
        unique: {
          args: true,
          msg: 'Username sudah digunakan!',
        },
        allowNull: false,
        validate: {
          notNull: {
            msg: 'Masukkan username anda!',
          },
        },
      },
      email: {
        type: DataTypes.STRING,
        unique: {
          args: true,
          msg: 'Email sudah digunakan!',
        },
        allowNull: false,
        validate: {
          notNull: {
            msg: 'Masukkan email anda!',
          },
          isEmail: {
            msg: 'Data email yang anda masukkan salah!',
          },
        },
      },
      role: {
        type: DataTypes.ENUM('superadmin', 'admin', 'user'),
        allowNull: false,
        validate: {
          notNull: {
            msg: 'Masukkan role user!',
          },
        },
      },
      password_hash: {
        type: DataTypes.TEXT,
        allowNull: false,
        validate: {
          notNull: {
            msg: 'Masukkan password user!',
          },
        },
      },
      photo_path: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      photo_url: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      last_login_time: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
    }, {
      uniqueKeys: {
        unique_tag: {
          customIndex: true,
          fields: ['id', 'username', 'email'],
        },
      },
    });
  },
  down: async ({ context: queryInterface }) => {
    await queryInterface.dropTable('users');
  },
};
