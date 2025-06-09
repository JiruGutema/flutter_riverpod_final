const { StatusCodes } = require("http-status-codes")
const jwt = require("jsonwebtoken")


async function authMiddleware(req,res,next){ 
    console.log("middle ware") 
    const authHeader = req.headers.authorization
    console.log("authHeader",authHeader)
    if(!authHeader || !authHeader.startsWith("Bearer ")){
       return res.status(StatusCodes.UNAUTHORIZED).json({msg:" 1 unauthorized", valid:false})
}
const token = authHeader.split(" ")[1]
console.log("Checking User")
try{
    const {username,userid,role} = jwt.verify(token,process.env.JWT_SECRET)
    req.user = {username,userid,role, valid:true}
    next()
}catch(err){
    console.log(err)
    return res.status(StatusCodes.UNAUTHORIZED).json({msg:"2 unauthorized", valid:false})

}

}
module.exports = authMiddleware
