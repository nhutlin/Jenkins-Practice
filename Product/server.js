const express = require('express');
const cors = require('cors');
const app = express();


require('dotenv').config();
require('./config/db_conn');
const port = process.env.PORT || 9000;

const corsOptions = {
    origin: '*',
    methods: 'GET,POST,PUT,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type,Authorization',
    credentials: true
};
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/products", require("./routes/productRouter"))
app.use("/filter", require("./routes/filterRouter"))

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
