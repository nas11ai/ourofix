const express = require('express');

const app = express();
const { PORT } = require('./src/configs/config');
const { connectToDatabase } = require('./src/configs/db');

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

app.get('/', (req, res) => {
  res.send('NA Database API is running 🥳');
});

const main = async () => {
  await connectToDatabase();
  app.listen(PORT, () => {
    // eslint-disable-next-line no-console
    console.log(`Server is running on port ${PORT}`);
  });
};

main();
