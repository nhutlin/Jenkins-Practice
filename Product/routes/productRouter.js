const express = require('express');
const productController = require('../controllers/productController');
const router = express.Router();

router.get('/', productController.getProducts);

router.get('/:idOrName', productController.findProduct);

router.post('/', productController.createProduct);

router.get("/", (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", "*"); // Hoặc cấu hình cụ thể
    res.json({ message: "Products endpoint" });
  });

module.exports = router;
