const express = require('express');
const cors = require('cors');
const app = express();


require('dotenv').config();
require('./config/db_conn');
const port = process.env.PORT || 9000;

// Enable cors
app.use(cors({
    origin: '*'
  }));
  
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/products", require("./routes/productRouter"))
app.use("/filter", require("./routes/filterRouter"))

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
