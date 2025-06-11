const express = require("express");
const router = express.Router();
const { updateUserRoleToVolunteer, updateUserRoleToOrg,getAllUsers, deleteUser, updateUser, getUserById } = require("../controllers/user.controller");
const { register, login, checkUser } = require("../controllers/auth.controller");
const authMiddleware = require("../middlewares/authMiddleware");
const adminMiddleware = require("../middlewares/adminMiddleware");

router.post("/auth/register", register); //register
router.post("/auth/login", login); //login
router.get("/users/:userId/profile", getUserById); // get user profile
router.get("/checkUser",authMiddleware, checkUser); // check user authentication
router.put("/users/:userId",updateUser) // update user profile
router.put("/:userId/role/host", authMiddleware, updateUserRoleToOrg);  
router.put("/:userId/role/guest", authMiddleware, updateUserRoleToVolunteer); // update user role to volunteer
router.delete("/user",  deleteUser); // delete user using token



module.exports = router;

