const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { User } = require('../../models');
const { v4: uuidv4 } = require('uuid'); // Impor uuidv4
const {
  REFRESH_TOKEN_SECRET,
  ACCESS_TOKEN_SECRET,
  TOKEN_ALGORITHM,
  TOKEN_ISSUER,
  TOKEN_AUDIENCE,
} = require('../../../../configs/config');
const loginService = require('../login');

jest.mock('jsonwebtoken');
jest.mock('bcrypt');
jest.mock('../../models');
jest.mock('uuid'); // Mock uuidv4

describe('loginService', () => {
  it('should return new access and refresh tokens on successful login', async () => {
    const req = {
      body: {
        username: 'validUser',
        password: 'validPassword',
      },
    };

    const user = {
      id: uuidv4(), // Gunakan uuidv4 untuk ID user
      username: 'validUser',
      password_hash: 'hashedValidPassword',
      role: 'user',
    };

    User.findOne.mockResolvedValue(user);
    bcrypt.compare.mockResolvedValue(true);

    const mockAccessToken = 'mockAccessToken';
    const mockRefreshToken = 'mockRefreshToken';
    jwt.sign.mockReturnValueOnce(mockAccessToken);
    jwt.sign.mockReturnValueOnce(mockRefreshToken);

    const result = await loginService(req);

    expect(User.findOne).toHaveBeenCalledWith({ where: { username: 'validUser' } });
    expect(bcrypt.compare).toHaveBeenCalledWith('validPassword', 'hashedValidPassword');
    expect(jwt.sign).toHaveBeenCalledWith(
      {
        userId: user.id,
        userRole: 'user',
        username: 'validUser',
      },
      ACCESS_TOKEN_SECRET,
      {
        algorithm: TOKEN_ALGORITHM,
        issuer: TOKEN_ISSUER,
        audience: TOKEN_AUDIENCE,
        expiresIn: '10m', // Sesuai dengan konfigurasi
      }
    );
    expect(jwt.sign).toHaveBeenCalledWith(
      { userId: user.id },
      REFRESH_TOKEN_SECRET,
      {
        jwtid: expect.any(String),
        algorithm: TOKEN_ALGORITHM,
        issuer: TOKEN_ISSUER,
        audience: TOKEN_AUDIENCE,
        expiresIn: '1d', // Sesuai dengan konfigurasi
      }
    );

    expect(result).toEqual({
      newAccessToken: mockAccessToken,
      newRefreshToken: mockRefreshToken,
      userRole: 'user',
    });
  });
});
