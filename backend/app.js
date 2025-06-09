require("dotenv").config();
const express = require("express");
const path = require('path');

const app = express();
const port = process.env.PORT || 5500;
const cors = require("cors");
app.use('/public', express.static(path.join(__dirname, 'src', 'public')));

app.use(express.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));

const userRoutes = require("./src/routes/user.routes")
const appRoutes = require("./src/routes/application.route");
app.use("/api", userRoutes);
app.use("/api", appRoutes);


async function start() {
  try {
    app.listen(port, () => {
      console.log(`Listening on port http://localhost:${port}`);
      
    });
    console.log("Database connection established");
  } catch (error) {
    console.log(error.message);
  }
}
start();
