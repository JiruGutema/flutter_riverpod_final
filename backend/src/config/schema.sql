-- Active: 1737887074325@@127.0.0.1@3306
-- USER TABLE
create database volunteer;
USE volunteer;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, 
    role VARCHAR(50) NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    city VARCHAR(100) DEFAULT NULL,
    bio TEXT DEFAULT NULL,
    attended_events INT DEFAULT 0,
    hours_volunteered INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    skill VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE user_interests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    interest VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
-- Events
CREATE TABLE events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  uuid VARCHAR(255) NOT NULL,
  org_id INT,
  title TEXT,
  subtitle TEXT,
  category TEXT,
  date TEXT,
  time TEXT,
  location TEXT,
  spotsLeft INTEGER,
  image TEXT,
  description TEXT,
  requirements TEXT,      -- Stored as JSON string
  additionalInfo TEXT,    -- Stored as JSON string
  contactPhone TEXT,
  contactEmail TEXT,
  contactTelegram TEXT
);


-- Applications
CREATE TABLE applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    event_id INT,  -- Now matches events.id type
    status ENUM('Pending', 'Approved', 'Canceled') NOT NULL DEFAULT 'Pending',
    applied_date DATE NOT NULL,
    title VARCHAR(100) NOT NULL,
    Organization VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    event_time VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);



