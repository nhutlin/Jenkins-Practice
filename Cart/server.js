const express = require('express');
const cors = require('cors');
const app = express();


require('dotenv').config();
require('./config/db_conn');
const port = process.env.PORT || 9003;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
    cors({
      origin: '*',
      methods: ["GET", "POST", "PUT", "DELETE"],
      credentials: true,
    })
  );


app.use("/cart", require("./routes/cartRouter"))

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
