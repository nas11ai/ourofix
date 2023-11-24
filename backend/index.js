const express = require('express');
const ngrok = require('ngrok');

const app = express();
const { PORT } = require('./src/configs/config');
const { connectToDatabase } = require('./src/configs/db');

const errorHandler = require('./src/middlewares/error_handler');
const authMiddleware = require('./src/middlewares/auth_middleware');

const usersRouter = require('./src/features/user/routes');
const orderController = require('./src/features/order/routes');

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Ourofix API is running 🥳');
});

app.use(authMiddleware);

app.use('/users', usersRouter);
app.use('/order', orderController);

const main = async () => {
  await connectToDatabase();
  app.listen(PORT, () => {
    // eslint-disable-next-line no-console
    // console.log(`Server is running on port ${PORT}`);
  });
  const url = await ngrok.connect(PORT);
  // eslint-disable-next-line no-console
  console.log(url);
};

main();

app.use(errorHandler);

module.exports = app;
