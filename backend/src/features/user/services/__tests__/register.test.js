const bcrypt = require('bcrypt');
const { User } = require('../../models');
const HttpStatus = require('../../../../utilities/http_status');
const generateErrorResponse = require('../../../../utilities/generate_error_response');
const registerService = require('../register');

jest.mock('bcrypt');
jest.mock('../../models');
jest.mock('../../../../../utilities/generate_error_response');

describe('registerService', () => {
  it('should create a new user', async () => {
    const req = {
      body: {
        username: 'newuser',
        role: 'user',
        password: 'password',
        email: 'user@example.com',
      },
    };

    const mockCreate = jest.fn();
    User.findOne.mockResolvedValue(null);
    User.create.mockImplementation(mockCreate);
    bcrypt.hash.mockResolvedValue('hashedpassword');

    await registerService(req);

    expect(User.findOne).toHaveBeenCalledWith({ where: { username: 'newuser' } });
    expect(User.create).toHaveBeenCalledWith({
      username: 'newuser',
      role: 'user',
      password_hash: 'hashedpassword',
      email: 'user@example.com',
    });
  });

  it('should return an error if username is not a string', async () => {
    const req = {
      body: {
        username: 123, // Non-string value
        role: 'user',
        password: 'password',
        email: 'user@example.com',
      },
    };

    try {
      await registerService(req);
    } catch (error) {
      expect(error.name).toBe('ValidationError');
      expect(error.attribute).toBe('username');
      expect(error.message).toBe('username harus berupa string dan tidak boleh kosong!');
    }
  });

  it('should return an error if username is already taken', async () => {
    const req = {
      body: {
        username: 'existingUser',
        role: 'user',
        password: 'password',
        email: 'user@example.com',
      },
    };

    User.findOne.mockResolvedValue({ username: 'existingUser' });

    try {
      await registerService(req);
    } catch (error) {
      expect(error.name).toBe('RegisterError');
      expect(error.attribute).toBe('username');
      expect(error.message).toBe('username telah digunakan!');
      expect(generateErrorResponse).toHaveBeenCalledWith({
        name: 'RegisterError',
        attribute: 'username',
        message: 'username telah digunakan!',
        httpStatus: HttpStatus.BAD_REQUEST,
      });
    }
  });
});
