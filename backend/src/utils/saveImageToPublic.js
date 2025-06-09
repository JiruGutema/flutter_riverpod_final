const multer = require('multer');
const path = require('path');
const fs = require('fs');

const storage = multer.diskStorage({
  
  destination: function (req, file, cb) {
    const uploadPath = path.join(__dirname, '..', 'public', 'images');
    fs.mkdirSync(uploadPath, { recursive: true });
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    const uniqueName = `${Date.now()}-${Math.round(Math.random() * 1e9)}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  }
});

const upload = multer({ storage });

function saveImageToPublic(req, res, next) {
  upload.single('image')(req, res, function (err) {
    if (err) {
      return res.status(500).json({ message: 'Image upload failed', error: err.message });
    }
    next(); 
  });
}

module.exports = { saveImageToPublic };
