const { StatusCodes } = require("http-status-codes");
const dbConnection = require("../config/db");
const { hash, compare } = require("bcrypt");
require("dotenv").config();
const jwt = require("jsonwebtoken");

async function register(req, res) {
  const { name, email, password } = req.body;
  const role = req.body.role || "volunteer"; 
  console.log(name, email)

  if (!email || !password || !name) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "All fields are required" });
  }

  if (password.length < 6) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "Password must be at least 6 characters" });
  }

  let connection;
  try {
    connection = await dbConnection.getConnection();
    await connection.beginTransaction();

    const [existingUser] = await connection.query(
      "SELECT email FROM users WHERE email = ?",
      [email]
    );

    if (existingUser?.length) {
      await connection.rollback();
      return res
        .status(StatusCodes.BAD_REQUEST)
        .json({ message: "Account already registered" });
    }

    const hashedPassword = await hash(password, 10);

    const [result] = await connection.query(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
      [name, email, hashedPassword, role]
    );

    const userId = result.insertId;

    const defaultSkills = [' '];
    const defaultInterests = [' '];

    if (defaultSkills.length) {
      const skillValues = defaultSkills.map(skill => [userId, skill]);
      await connection.query(
        "INSERT INTO user_skills (user_id, skill) VALUES ?",
        [skillValues]
      );
    }

    if (defaultInterests.length) {
      const interestValues = defaultInterests.map(interest => [userId, interest]);
      await connection.query(
        "INSERT INTO user_interests (user_id, interest) VALUES ?",
        [interestValues]
      );
    }

    await connection.commit();

    const token = jwt.sign(
      { name, userId, role },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    return res.status(StatusCodes.CREATED).json({ 
      message: "Registration success", 
      token,
      user: { name, id: userId, role, email }
    });

  } catch (error) {
    if (connection) await connection.rollback();
    console.error("Registration error:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Registration failed, please try again" });
  } finally {
    if (connection) connection.release();
  }
}

async function login(req, res) {
  const { email, password } = req.body;
  console.log(email, password);

  if (!email || !password) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "Email and password are required" });
  }

  try {
    const [user] = await dbConnection.query(
      "SELECT id, name, password, role FROM users WHERE email = ?",
      [email]
    );

    if (!user || user.length === 0) {
      console.log("Invalid email or password - no user found");
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid email or password" });
    }

    const userData = user[0];
    console.log("userdata", userData);

    const validPassword = await compare(password, userData.password);
    console.log(password, userData.password, validPassword);

    if (!validPassword) {
      console.log("Invalid email or password - password mismatch");
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid email or password" });
    }

    const name = userData.name;
    const userid = userData.id;
    const role = userData.role;

    const token = jwt.sign({ name, userid, role }, process.env.JWT_SECRET, { expiresIn: "1d" });

    return res.status(StatusCodes.CREATED).json({ message: "Login success", token: token, user:{ name: name, id:userid, role: role, email: email } });
  } catch (error) {
    console.error("Login error:", error.message, error.stack);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function checkUser(req, res) {
  const name = req.user.name;
  const userid = req.user.userid;
  res.status(StatusCodes.OK).json({ message: "valid user", name, userid, success: true });
}

module.exports = {
    register,
    login,
    checkUser
    };
