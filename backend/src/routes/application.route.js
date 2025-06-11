const express = require("express");
const { saveImageToPublic } = require("../utils/saveImageToPublic");
const router = express.Router();
const { 
    createEvent, 
    getEventById, 
    deleteEvent, 
    updateEvent, 
    getAllEvents, 
    getOrganizationEvents, 
    getUserEventApplications, 
    getEventApplicants, 
    applyForEvent ,
    rejectApplication,
    approveApplication,
    deleteApplication

} = require("../controllers/application.controller");
const authMiddleware = require("../middlewares/authMiddleware");
const adminMiddleware = require("../middlewares/adminMiddleware");


router.post("/events/create", saveImageToPublic, createEvent); // create new event

router.get("/events/org", getOrganizationEvents) // all events by organization

router.delete('/applications/:id', deleteApplication);
router.patch('/applications/:id/approve', approveApplication);
router.patch('/applications/:id/reject', rejectApplication);

router.get("/event/:id", getEventById); // post details by id
router.delete("/event/:eventId", deleteEvent); // delete event by id
router.put("/event/update/:eventId", saveImageToPublic, updateEvent);  // update event by id

router.get("/events", getAllEvents);    // explore

router.get("/event/:eventId/applicants/",authMiddleware, getEventApplicants); // get all applicants for an event

router.get("/myApplication", getUserEventApplications) // get all applications by user

router.post("/event/apply/:eventId",authMiddleware, applyForEvent) // apply for event

module.exports = router;
