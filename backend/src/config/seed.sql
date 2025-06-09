
-- USER DUMMY DATA
INSERT INTO users (name, role, email, phone, city, bio, attended_events, hours_volunteered)
VALUES (
  'Jiru Gutema',
  'Volunteer',
  'Jethior1@gmail.com',
  '+251978556748',
  'New York NY',
  'Lorem ipsum dolor sit amet , consectectur adipiscing sed do elit',
  12,
  48
);


INSERT INTO user_skills (user_id, skill) VALUES
(1, 'Teaching'),
(1, 'First Aid'),
(1, 'Gardening');

INSERT INTO user_interests (user_id, interest) VALUES
(1, 'Environment'),
(1, 'Elderly Care');

-- AAPLICATION DUMMY DATA

INSERT INTO applications (
    user_id, status, applied_date, title, organization, event_date, event_time
)
VALUES (
    1, 'Approved', '2023-05-20', 'Community Garden Cleanup',
    'Green Earth Foundation', '2023-06-15', '09:00 - 13:00'
);

-- EVENTS DUMMY DATA

INSERT INTO events (
  id, title, subtitle, category, date, time, location, spotsLeft, image,
  description, requirements, additionalInfo,
  contactPhone, contactEmail, contactTelegram
) VALUES (
  '1',
  'Community Garden Cleanup',
  'Green Earth Foundation',
  'Environment',
  'Saturday, April 12, 2025',
  '9:00 AM – 1:00 PM',
  'Near Zawditi Memorial Hospital, Kazanolia',
  15,
  'assets/images/community.jpg',
  'A Community Garden Cleanup is a volunteer-driven event focused on maintaining and revitalizing a shared garden space used by a neighborhood, school, or organization.',
  '["Willingness to volunteer and work outdoors", "Basic physical ability (standing, lifting, bending, etc.)", "Punctuality – arrive on time and stay for the full shift if possible", "Respect for others and community property", "Often open to all ages"]',
  '["Light snacks and water will be provided", "You may earn volunteer hours (bring your time sheet if needed)", "Certification of participation available upon request"]',
  '09123456',
  'contact@volunteer.com',
  '@volunteer'
);
