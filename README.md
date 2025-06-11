*# VolunteerConnect

## Project Overview
VolunteerConnect is a local volunteering hub that connects volunteers with organizations seeking assistance. The platform allows organizations to post volunteer opportunities, and users can browse and apply for them. This project includes a REST API backend, authentication, and a mobile frontend built with Jetpack Compose and Flutter.

## 👥 Team Members

| Full Name        |   Student ID   | Section
|------------------|----------------|--------
| Jiru Gutema      |  UGR/5902/15   |    4
| Abigiya Daniel   |  UGR/5110/15   |    4
| Ashenafi Godana  |  UGR/7906/14   |    4
| Blen Debebe      |  UGR/5297/15   |    4
| Anansi Sime      |  UGR/9691/15   |    2

## Features
### 1. Volunteer Opportunities (CRUD)
- Organizations can **Create, Read, Update, and Delete** volunteer opportunities.
- Volunteers can view available events and apply.

### 2. Volunteer Applications (CRUD)
- Volunteers can **Apply, View, Update, and Cancel** their applications.
- Organizations can manage applications for their events.

### 3. Authentication & Authorization
- **User Roles:**
    - **Volunteers**: Can browse and apply for opportunities.
    - **Organizations**: Can post and manage volunteer events.
    - **Admins (Optional)**: Can manage users and events.
- Secure authentication using **JWT/OAuth**.

### 4. Backend (REST API)
- Developed using **Express.js**.
- Serves the mobile front end.
- Implements authentication, authorization, and CRUD operations.

### 5. Testing
- **Unit Testing** (API endpoints and logic)
- **Integration Testing** (Ensuring API and frontend work together)

## Tech Stack
### Backend
- **Express.js** (REST API)
- **MySQL** (Database)
- **JWT/OAuth** (Authentication)

### Frontend
- **Jetpack Compose (Kotlin)** (First mobile version)
- **Flutter (Dart)** (Recreated mobile version)


