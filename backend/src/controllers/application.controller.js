const dbConnection = require("../config/db");
const { StatusCodes } = require("http-status-codes");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const {getBase64ImageFromUrl} = require("../utils/serveImage");
const db = require("../config/db");

async function createEvent(req, res) {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const org_id = decoded.userid; 
    const org_role = decoded.role; 
    console.log(org_role)

    if (org_role !== 'Organization') {
      return res.status(StatusCodes.FORBIDDEN).json({ message: "Only Organizations can create events" });
    }

const { 
  title, subtitle, category, date, time, location,
  spotsLeft, description, requirements,
  additionalInfo, contactPhone, contactEmail, contactTelegram
} = req.body;
console.log(req.body)

const image = req.file ? `/images/${req.file.filename}` : null;


    if (!title || !date || !time || !location) {
      return res.status(StatusCodes.BAD_REQUEST).json({ 
        message: "Title, date, time, and location are required" 
      });
    }

    const uuid = uuidv4();
    const parsedRequirements = requirements ? JSON.stringify(requirements) : null;
    const parsedAdditionalInfo = additionalInfo ? JSON.stringify(additionalInfo) : null;

    const [result] = await dbConnection.query(
      `INSERT INTO events (
        uuid, org_id, title, subtitle, category, date, time, location,
        spotsLeft, image, description, requirements, additionalInfo,
        contactPhone, contactEmail, contactTelegram
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        uuid, org_id, title, subtitle, category, date, time, location,
        spotsLeft || 0, image, description, parsedRequirements, parsedAdditionalInfo,
        contactPhone, contactEmail, contactTelegram
      ]
    );

    const [newEvent] = await dbConnection.query(
      "SELECT * FROM events WHERE uuid = ?", 
      [uuid]
    );
    console.log("Event Created Successfully")
    return res.status(StatusCodes.CREATED).json({
      message: "Event created successfully",
      event: {
        ...newEvent[0],
        requirements: newEvent[0].requirements ? JSON.parse(newEvent[0].requirements) : null,
        additionalInfo: newEvent[0].additionalInfo ? JSON.parse(newEvent[0].additionalInfo) : null
      }
    });

  } catch (error) {
    console.error("Create Event Error:", error.message);
    
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to create event" 
    });
  }
}

async function updateEvent(req, res) {
  const { eventId } = req.params;
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const org_id = decoded.userid;
    const org_role = decoded.role;

    if (org_role !== 'Organization') {
      return res.status(StatusCodes.FORBIDDEN).json({ message: "Only Organizations can update events" });
    }

    const [event] = await dbConnection.query(
      "SELECT org_id FROM events WHERE id = ?", 
      [eventId]
    );

    if (!event || event.length === 0) {
      return res.status(StatusCodes.NOT_FOUND).json({ message: "Event not found" });
    }

    if (event[0].org_id !== org_id) {
      return res.status(StatusCodes.FORBIDDEN).json({ 
        message: "You can only update your Organization's events" 
      });
    }

    const { 
  title, subtitle, category, date, time, location,
  spotsLeft, description, requirements,
  additionalInfo, contactPhone, contactEmail, contactTelegram
} = req.body;decoded.role !== "Organization"

const image = req.file ? `/images/${req.file.filename}` : null;

    const parsedRequirements = requirements ? JSON.stringify(requirements) : null;
    const parsedAdditionalInfo = additionalInfo ? JSON.stringify(additionalInfo) : null;

    await dbConnection.query(
      `UPDATE events SET
        title = COALESCE(?, title),
        subtitle = COALESCE(?, subtitle),
        category = COALESCE(?, category),
        date = COALESCE(?, date),
        time = COALESCE(?, time),
        location = COALESCE(?, location),
        spotsLeft = COALESCE(?, spotsLeft),
        image = COALESCE(?, image),
        description = COALESCE(?, description),
        requirements = COALESCE(?, requirements),
        additionalInfo = COALESCE(?, additionalInfo),
        contactPhone = COALESCE(?, contactPhone),
        contactEmail = COALESCE(?, contactEmail),
        contactTelegram = COALESCE(?, contactTelegram)
      WHERE id = ?`,
      [
        title, subtitle, category, date, time, location,
        spotsLeft, image, description, parsedRequirements, parsedAdditionalInfo,
        contactPhone, contactEmail, contactTelegram,
        eventId
      ]
    );

    const [updatedEvent] = await dbConnection.query(
      "SELECT * FROM events WHERE id = ?",
      [eventId]
    );

    return res.status(StatusCodes.OK).json({
      message: "Event updated successfully",
      event: {
        ...updatedEvent[0],
        requirements: updatedEvent[0].requirements ? JSON.parse(updatedEvent[0].requirements) : null,
        additionalInfo: updatedEvent[0].additionalInfo ? JSON.parse(updatedEvent[0].additionalInfo) : null
      }
    });

  } catch (error) {
    console.error("Update Event Error:", error.message);
    
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to update event" 
    });
  }
}

async function deleteEvent(req, res) {
  const { eventId } = req.params;
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const org_id = decoded.userid;
    const org_role = decoded.role;

    if (org_role !== 'Organization') {
      return res.status(StatusCodes.FORBIDDEN).json({ message: "Only Organizations can delete events" });
    }

    const [event] = await dbConnection.query(
      "SELECT org_id FROM events WHERE id = ?", 
      [eventId]
    );

    if (!event || event.length === 0) {
      return res.status(StatusCodes.NOT_FOUND).json({ message: "Event not found" });
    }

    if (event[0].org_id !== org_id) {
      return res.status(StatusCodes.FORBIDDEN).json({ 
        message: "You can only delete your Organization's events" 
      });
    }

    await dbConnection.query(
      "DELETE FROM events WHERE id = ?",
      [eventId]
    );

    return res.status(StatusCodes.OK).json({ 
      message: "Event deleted successfully" 
    });

  } catch (error) {
    console.error("Delete Event Error:", error.message);
    
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to delete event" 
    });
  }
}

async function getEventById(req, res) {

  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const userId = decoded.userid;
    const userRole = decoded.role;

    const id = req.params.id;

    const [application] = await dbConnection.query(
      "SELECT * FROM  events WHERE id = ?", 
      [id]
    );

    if (!application.length) {
      return res.status(StatusCodes.NOT_FOUND).json({ message: "Application not found" });
    }

    const applicationData = application[0];



    let base64Image = null;
    const baseURL = 'http://localhost:5500/public'; 
    if (applicationData.image) {
      base64Image = await getBase64ImageFromUrl(`${baseURL + applicationData.image}`);
      
    }

    const requirements = applicationData.requirements ? JSON.parse(applicationData.requirements) : null;
    const additionalInfo = applicationData.additionalInfo ? JSON.parse(applicationData.additionalInfo) : null;

    return res.status(StatusCodes.OK).json({
      id: applicationData.id,
      title: applicationData.title,
      subtitle: applicationData.subtitle,
      category: applicationData.category,
      date: applicationData.date,
      time: applicationData.time,
      location: applicationData.location,
      spotsLeft: applicationData.spotsLeft,
      image: base64Image, // Send Base64 image
      description: applicationData.description,
      requirements,
      additionalInfo,
      contactPhone: applicationData.contactPhone,
      contactEmail: applicationData.contactEmail,
      contactTelegram: applicationData.contactTelegram
    });

  } catch (error) {
    console.error("Get Application Error:", error.message);

    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: "Failed to retrieve application" });
  }
}


async function getAllEvents(req, res) {
  console.log("get all events");
  try {
    const [events] = await dbConnection.query("SELECT * FROM events");
    console.log(events)
    const baseURL = "http://localhost:5500/public";

    const parsedEvents = await Promise.all(events.map(async (event) => {
      const imagePath = event.image ? `${baseURL}${event.image}` : null;

      let base64Image = null;
      if (imagePath) {
        console.log("retrieving image from:", imagePath);
        base64Image = await getBase64ImageFromUrl(imagePath);
      }

      return {
        ...event,
        requirements: event.requirements ? JSON.parse(event.requirements) : null,
        additionalInfo: event.additionalInfo ? JSON.parse(event.additionalInfo) : null,
        image: base64Image, // Base64 encoded image
      };
    }));

    return res.status(StatusCodes.OK).json({ events: parsedEvents });

  } catch (error) {
    console.error("Get All Events Error:", error.message);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to retrieve events" 
    });
  }
}


async function getOrganizationEvents(req, res) {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(StatusCodes.UNAUTHORIZED).json({
      error: "Authorization token required"
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (decoded.role !== 'Organization') {
      return res.status(StatusCodes.FORBIDDEN).json({
        error: "Only Organizations can access this endpoint"
      });
    }

    const orgId = decoded.userid; // Get Organization ID from token

    const [events] = await dbConnection.query(`
      SELECT 
        id,
        uuid,
        title,
        subtitle,
        category,
        DATE_FORMAT(date, '%Y-%m-%d') AS date,
        DATE_FORMAT(time, '%h:%i %p') AS time,
        location,
        spotsLeft,
        image
      FROM events
      WHERE org_id = ?
      ORDER BY date DESC
    `, [orgId]);

    return res.status(StatusCodes.OK).json({
      events: events.map(event => ({
        id: event.id,
        uuid: event.uuid,
        title: event.title,
        subtitle: event.subtitle,
        category: event.category,
        date: event.date,
        time: event.time,
        location: event.location,
        spotsLeft: event.spotsLeft,
        image: event.image
      }))
    });

  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        error: "Invalid or expired token"
      });
    }

    console.error("Error fetching Organization events:", error);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      error: "Failed to fetch Organization events"
    });
  }
}

async function applyForEvent(req, res) {
  const { eventId } = req.params;
  const userId = req.user.userid;
  const targetEventId = eventId;

  let connection;
  try {
    connection = await dbConnection.getConnection();
    await connection.beginTransaction();

    const [event] = await connection.query(
      `SELECT 
        e.id,
        e.uuid,
        e.title,
        e.date,
        e.time,
        e.spotsLeft,
        e.contactEmail,
        o.name AS Organization_name
       FROM events e
       JOIN users o ON e.org_id = o.id
       WHERE e.id = ?
       FOR UPDATE`,
      [targetEventId]
    );

    if (!event.length) {
      await connection.rollback();
      return res.status(StatusCodes.NOT_FOUND).json({
        error: "Special event not available",
        details: "Event ID 2 is not currently available for applications",
        eventId: targetEventId
      });
    }

    const currentDate = new Date();
    const eventDate = new Date(event[0].date + 'T' + event[0].time);
    
    if (eventDate < currentDate) {
      await connection.rollback();
      return res.status(StatusCodes.BAD_REQUEST).json({
        error: "Special event has passed",
        details: {
          eventDate: eventDate.toISOString(),
          currentDate: currentDate.toISOString()
        }
      });
    }

    if (event[0].spotsLeft <= 0) {
      await connection.rollback();
      return res.status(StatusCodes.CONFLICT).json({
        error: "Special event is full",
        details: {
          remainingSpots: event[0].spotsLeft,
          contact: event[0].contactEmail
        }
      });
    }

    const [existingApp] = await connection.query(
      `SELECT id, status FROM applications 
       WHERE user_id = ? AND event_id = ?`,
      [userId, targetEventId]
    );

    if (existingApp.length > 0) {
      await connection.rollback();
      return res.status(StatusCodes.CONFLICT).json({
        error: "Existing application found",
        details: {
          applicationId: existingApp[0].id,
          currentStatus: existingApp[0].status
        }
      });
    }

    const [result] = await connection.query(
      `INSERT INTO applications (
        user_id,
        event_id,
        status,
        applied_date,
        title,
        Organization,
        event_date,
        event_time
      ) VALUES (?, ?, 'pending', NOW(), ?, ?, ?, ?)`,
      [
        userId,
        targetEventId,
        event[0].title,
        event[0].Organization_name,
        event[0].date,
        event[0].time
      ]
    );

    await connection.query(
      `UPDATE events SET spotsLeft = spotsLeft - 1 
       WHERE id = ?`,
      [targetEventId]
    );

    await connection.commit();

    return res.status(StatusCodes.CREATED).json({
      success: true,
      message: "Application to special event submitted",
      application: {
        id: result.insertId,
        event: {
          id: targetEventId,
          uuid: event[0].uuid,
          title: event[0].title,
          date: event[0].date,
          time: event[0].time
        },
        spotsRemaining: event[0].spotsLeft - 1,
        contact: event[0].contactEmail
      }
    });

  } catch (error) {
    if (connection) await connection.rollback();
    
    console.error("Special event application error:", error);
    
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      error: "Special event application failed",
      details: process.env.NODE_ENV === 'development' ? {
        message: error.message,
        code: error.code
      } : undefined
    });
  } finally {
    if (connection) connection.release();
  }
}

async function getEventApplicants(req, res) {
  const { eventId } = req.params;
  const orgId = req.user.userid; 

  try {
    const [event] = await dbConnection.query(
      `SELECT id FROM events WHERE id = ? AND org_id = ?`,
      [eventId, orgId]
    );

    if (!event.length) {
      return res.status(StatusCodes.NOT_FOUND).json({
        error: "Event not found or access denied"
      });
    }

    const [applicants] = await dbConnection.query(
      `SELECT
        u.id AS user_id,
        u.name,
     
        u.email,
        a.status,
        a.applied_date AS applied_at
      FROM applications a
      JOIN users u ON a.user_id = u.id
      WHERE a.event_id = ?
      ORDER BY a.applied_date DESC`,
      [eventId]
    );

    const response = applicants.map(applicant => ({
      user_id: applicant.user_id,
      name: applicant.name,
      email: applicant.email,
      status: applicant.status.toLowerCase(), 
      applied_at: applicant.applied_at.toISOString() 
    }));

    return res.status(StatusCodes.OK).json(response);

  } catch (error) {
    console.error("Error fetching applicants:", error);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      error: "Failed to fetch applicants",
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
}


async function getUserEventApplications(req, res) {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(StatusCodes.UNAUTHORIZED).json({
      error: "Authorization token required"
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const userId = decoded.userid;

    const [applications] = await dbConnection.query(`
      SELECT 
        a.id,
        a.event_id AS eventId,
        e.title,
        a.status,
        e.subtitle,
        e.category,
        DATE_FORMAT(e.date, '%Y-%m-%d') AS date,
        DATE_FORMAT(e.time, '%h:%i %p') AS time,
        DATE_FORMAT(a.applied_date, '%d, %m, %Y') AS appliedAt
      FROM applications a
      JOIN events e ON a.event_id = e.id
      WHERE a.user_id = ?
      ORDER BY a.applied_date DESC
    `, [userId]);

    const response = {
      events: applications.map(app => ({
        id: app.id.toString(),
        eventId: app.eventId.toString(),
        title: app.title,
        status: app.status,
        subtitle: app.subtitle,
        category: app.category,
        date: app.date,
        time: app.time,
        appliedAt: app.appliedAt
      }))
    };

    if (applications.length === 0) {
      return res.status(StatusCodes.OK).json({ 
        message: "No event applications found",
        events: [] 
      });
    }

    return res.status(StatusCodes.OK).json(response);

  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        error: "Invalid or expired token"
      });
    }

    console.error("Error fetching event applications:", error);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      error: "Failed to fetch event applications" 
    });
  }
}

const getTokenData = (req) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) return null;
  const token = authHeader.split(' ')[1];
  try {
    return jwt.verify(token, process.env.JWT_SECRET);
  } catch {
    return null;
  }
};

const deleteApplication = async (req, res) => {

  const tokenData = getTokenData(req);
  console.log("Token data:", tokenData); // Debug

  // Only allow users (not Organizations)
  if (tokenData?.role === "Organization") {
    return res.status(403).json({ message: 'Only users can delete applications.' });
  }

  const applicationId = req.params.id;

  if (!applicationId) {
    return res.status(400).json({ message: 'Application ID is required.' });
  }

  try {
    console.log(`Trying to delete application ID ${applicationId} for user ID ${tokenData.userid}`);

    const [result] = await dbConnection.execute(
      'DELETE FROM applications WHERE id = ? AND user_id = ?',
      [applicationId, tokenData.userid]
    );

    console.log("Delete result:", result);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Application not found or not owned by user.' });
    }

    return res.status(200).json({ message: 'Application deleted successfully.' });

  } catch (error) {
    console.error("Delete error:", error); // ✅ This will now show the real issue
    return res.status(500).json({
      message: 'Error deleting application',
      error: error.message || error.toString(),
    });
  }
};

const approveApplication = async (req, res) => {

  const tokenData = getTokenData(req);
  if (!tokenData?.role == "volunteer") {
    return res.status(403).json({ message: 'Only Organizations can approve applications.' });
  }

  const applicationId = req.params.id;

  try {
    const [check] = await dbConnection.execute(
      'SELECT * FROM applications WHERE id = ? AND Organization = ?',
      [applicationId, tokenData.name]
    );
    
    if (check.length === 0) {
      console.log("in approve")
      return res.status(404).json({ message: 'Application not found or not associated with your Organization.' });
    }

    await dbConnection.execute(
      'UPDATE applications SET status = ? WHERE id = ?',
      ['Approved', applicationId]
    );

    res.status(200).json({ message: 'Application approved.' });
  } catch (error) {
    res.status(500).json({ message: 'Error approving application', error });
  }
};


const rejectApplication = async (req, res) => {
  
  const tokenData = getTokenData(req);
  if (!tokenData?.role == "volunteer") {
    return res.status(403).json({ message: 'Only Organizations can approve applications.' });
  }

  const applicationId = req.params.id;

  try {
    const [check] = await dbConnection.execute(
      'SELECT * FROM applications WHERE id = ? AND Organization = ?',
      [applicationId, tokenData.name]
    );

    if (check.length === 0) {
      return res.status(404).json({ message: 'Application not found or not associated with your Organization.' });
    }

    await dbConnection.execute(
      'UPDATE applications SET status = ? WHERE id = ?',
      ['Canceled', applicationId]
    );

    res.status(200).json({ message: 'Application approved.' });
  } catch (error) {
    res.status(500).json({ message: 'Error approving application', error });
  }
};

module.exports = {
    createEvent,
    updateEvent,
    deleteEvent,
    getEventById,
    getAllEvents,
    getOrganizationEvents,
    applyForEvent,
    getUserEventApplications,
    getEventApplicants,
    deleteApplication,
    approveApplication,
    rejectApplication
    };
