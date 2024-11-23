const express = require('express');
const cors = require('cors');
const app = express();


require('dotenv').config();
require('./config/db_conn');
const port = process.env.PORT || 9001;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*"); // update to match the domain you will make the request from
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

app.use("/users", require("./routes/userRouter"))



app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
