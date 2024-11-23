const express = require('express');
const cors = require('cors');
const app = express();


require('dotenv').config();
require('./config/db_conn');
const port = process.env.PORT || 9000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
router.get("/", (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", "*"); // Hoặc cấu hình cụ thể
    res.json({ message: "Products endpoint" });
  });
app.use("/products", require("./routes/productRouter"))
app.use("/filter", require("./routes/filterRouter"))

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
