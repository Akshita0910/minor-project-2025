-- ===================== USERS TABLE =====================
CREATE TABLE Users (
    user_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role ENUM('student', 'faculty', 'admin') NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

INSERT INTO Users (user_id, name, role, password_hash) VALUES
('241032002', 'Avika Aswal', 'student', 'AA@002'),
('241033016', 'Mannat Arora', 'student', 'MA@016'),
('241034007', 'Akshita Sood', 'student', 'AS@007'),
('241030431', 'Divyansh Sharma', 'student', 'DS@431'),
('241033075', 'Aryan Thakur', 'student', 'AT@075'),
('VSG', 'Vivek Sehgal', 'faculty', 'VSG@101'),
('PKR', 'Pardeep Kumar', 'faculty', 'PKR@102'),
('RBT', 'Ravindara Bhatt', 'faculty', 'RBT@103'),
('AVR', 'Arvind Kumar', 'faculty', 'AVR@104'),
('AVA', 'Amol Vasudeva', 'faculty', 'Ava@105'),
('PMI', 'Praveen Modi', 'faculty', 'PMI@106'),
('RIV', 'Ruchi Verma', 'faculty', 'RIV@107'),
('EGA', 'Ekta Gandotra', 'faculty', 'EGA@108'),
('AKJ', 'Amit Kumar Jakhar', 'faculty', 'AKJ@109'),
('HRI', 'Hari Singh', 'faculty', 'HRI@110'),
('PTK', 'Prateek Thakral', 'faculty', 'PTK@111'),
('AMN', 'Aman Sharma', 'faculty', 'AMN@112'),
('RKI', 'Rakesh Kanji', 'faculty', 'RKI@113'),
('DGA', 'Deepak Gupta', 'faculty', 'DGA@114'),
('VKS', 'Vipul Kumar Sharma', 'faculty', 'VKS@115'),
('PDN', 'Pankaj Dhiman', 'faculty', 'PDN@116'),
('NSA', 'Nancy Singla', 'faculty', 'NSA@117'),
('KLK', 'Kushal Kanwar', 'faculty', 'KLK@118'),
('FSL', 'Faisal Firdous', 'faculty', 'FSL@119'),
('AYS', 'Aayush Sharma', 'faculty', 'AYS@120'),
('GRN', 'Gaurav Negi', 'faculty', 'GRN@121'),
('MNK', 'Monika', 'faculty', 'MNKI@122'),
('ADM01', 'System Admin', 'admin', 'ADM@001');

-- ===================== ADMINS TABLE =====================
CREATE TABLE Admins (
    admin_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES Users(user_id)
);

INSERT INTO Admins (admin_id, name, password_hash) VALUES
('ADM01', 'System Admin', 'ADM@001');

-- ===================== ADMIN ACTIONS LOG =====================
CREATE TABLE AdminActions (
    action_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id VARCHAR(20),
    action_type ENUM('add_student', 'add_faculty', 'upload_timetable') NOT NULL,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    FOREIGN KEY (admin_id) REFERENCES Admins(admin_id)
);

-- ===================== CAPTCHA LOGS =====================
CREATE TABLE CaptchaLogs (
    captcha_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- ===================== SUBJECTS =====================
CREATE TABLE Subjects (
    subject_code VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    type ENUM('Lecture', 'Practical') NOT NULL
);

INSERT INTO Subjects (subject_code, name, type) VALUES
('18B11CI211', 'DSA', 'Lecture'),
('18B17CI271', 'DSA', 'Practical');

-- ===================== BATCHES =====================
CREATE TABLE Batches (
    batch_code VARCHAR(20) PRIMARY KEY
);

INSERT INTO Batches(batch_code) VALUES
('24A11'), ('24A12'), ('24A13'), ('24A14'), ('24A15'), ('24A16'),
('24A17'), ('24A18'), ('24A19'), ('24A110'), ('24A111'), ('24A112'),
('24J11'), ('24K11'), ('24I13'), ('24I11');

-- ===================== STUDENT-BATCH MAPPING =====================
CREATE TABLE StudentBatch (
    user_id VARCHAR(20),
    batch_code VARCHAR(20),
    PRIMARY KEY (user_id, batch_code),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (batch_code) REFERENCES Batches(batch_code)
);

INSERT INTO StudentBatch (user_id, batch_code) VALUES
('241032002', '24K11'),
('241033016', '24I11'),
('241034007', '24J11'),
('241030431', '24A11'),
('241033075', '24I13');

-- ===================== TIMETABLE =====================
CREATE TABLE Timetable (
    timetable_id INT AUTO_INCREMENT PRIMARY KEY,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    subject_code VARCHAR(20),
    faculty_id VARCHAR(20),
    batch_code VARCHAR(20),
    room VARCHAR(20),
    status ENUM('scheduled', 'rescheduled') DEFAULT 'scheduled',
    FOREIGN KEY (subject_code) REFERENCES Subjects(subject_code),
    FOREIGN KEY (faculty_id) REFERENCES Users(user_id),
    FOREIGN KEY (batch_code) REFERENCES Batches(batch_code)
);

INSERT INTO Timetable (day_of_week, start_time, end_time, subject_code, faculty_id, batch_code, room) VALUES
('Monday', '09:00:00', '11:00:00', '18B17CI271', 'AVA', '24A11', 'CL7'),
('Thursday', '15:00:00', '17:00:00', '18B17CI271', 'AVA', '24A11', 'CL7'),
('Tuesday', '16:00:00', '17:00:00', '18B11CI211', 'AVA', '24A11', 'CR5'),
('Thursday', '09:00:00', '10:00:00', '18B11CI211', 'AVA', '24A11', 'CR5'),
('Friday', '15:00:00', '16:00:00', '18B11CI211', 'AVA', '24A11', 'CR5'),

('Monday', '11:00:00', '13:00:00', '18B17CI271', 'GRN', '24J11', 'CL8'),
('Wednesday', '15:00:00', '17:00:00', '18B17CI271', 'GRN', '24J11', 'CL9'),
('Tuesday', '15:00:00', '16:00:00', '18B11CI211', 'GRN', '24J11', 'CR5'),
('Wednesday', '09:00:00', '10:00:00', '18B11CI211', 'GRN', '24J11', 'CR5'),
('Friday', '09:00:00', '10:00:00', '18B11CI211', 'GRN', '24J11', 'CR5'),

('Thursday', '11:00:00', '13:00:00', '18B17CI271', 'GRN', '24K11', 'CL9'),
('Friday', '11:00:00', '13:00:00', '18B17CI271', 'GRN', '24K11', 'CL9'),
('Tuesday', '15:00:00', '16:00:00', '18B11CI211', 'GRN', '24K11', 'CR5'),
('Wednesday', '09:00:00', '10:00:00', '18B11CI211', 'GRN', '24K11', 'CR5'),
('Friday', '09:00:00', '10:00:00', '18B11CI211', 'GRN', '24K11', 'CR5'),

('Thursday', '11:00:00', '13:00:00', '18B17CI271', 'AKJ', '24I13', 'CL4'),
('Thursday', '15:00:00', '17:00:00', '18B17CI271', 'AKJ', '24I13', 'CL9'),
('Monday', '09:00:00', '10:00:00', '18B11CI211', 'AKJ', '24I13', 'CR9'),
('Wednesday', '11:00:00', '12:00:00', '18B11CI211', 'AKJ', '24I13', 'CR2'),
('Friday', '13:00:00', '14:00:00', '18B11CI211', 'AKJ', '24I13', 'CR9'),

('Tuesday', '13:00:00', '15:00:00', '18B17CI271', 'AKJ', '24I11', 'CL4'),
('Thursday', '15:00:00', '17:00:00', '18B17CI271', 'AKJ', '24I11', 'CL4'),
('Monday', '09:00:00', '10:00:00', '18B11CI211', 'AKJ', '24I11', 'CR9'),
('Wednesday', '11:00:00', '12:00:00', '18B11CI211', 'AKJ', '24I11', 'CR2'),
('Friday', '13:00:00', '14:00:00', '18B11CI211', 'AKJ', '24I11', 'CR9');

-- ===================== RESCHEDULE LOGS =====================
CREATE TABLE RescheduleLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    timetable_id INT,
    original_day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    original_start_time TIME,
    original_end_time TIME,
    new_day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    new_start_time TIME,
    new_end_time TIME,
    rescheduled_by VARCHAR(20),
    reschedule_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    class_function ENUM('TR', 'CR') NOT NULL,
    FOREIGN KEY (timetable_id) REFERENCES Timetable(timetable_id),
    FOREIGN KEY (rescheduled_by) REFERENCES Users(user_id)
);

-- ===================== TIME SLOT AVAILABILITY QUERY =====================
WITH time_slots(day, start_time, end_time) AS (
  SELECT * FROM (
    SELECT 'Monday', '08:00:00', '09:00:00' UNION ALL
    SELECT 'Monday', '09:00:00', '10:00:00' UNION ALL
    SELECT 'Monday', '10:00:00', '11:00:00' UNION ALL
    SELECT 'Monday', '11:00:00', '12:00:00' UNION ALL
    SELECT 'Monday', '12:00:00', '13:00:00' UNION ALL
    SELECT 'Monday', '13:00:00', '14:00:00' UNION ALL
    SELECT 'Monday', '14:00:00', '15:00:00' UNION ALL
    SELECT 'Monday', '15:00:00', '16:00:00' UNION ALL
    SELECT 'Monday', '16:00:00', '17:00:00' UNION ALL

    SELECT 'Tuesday', '08:00:00', '09:00:00' UNION ALL
    SELECT 'Tuesday', '09:00:00', '10:00:00' UNION ALL
    SELECT 'Tuesday', '10:00:00', '11:00:00' UNION ALL
    SELECT 'Tuesday', '11:00:00', '12:00:00' UNION ALL
    SELECT 'Tuesday', '12:00:00', '13:00:00' UNION ALL
    SELECT 'Tuesday', '13:00:00', '14:00:00' UNION ALL
    SELECT 'Tuesday', '14:00:00', '15:00:00' UNION ALL
    SELECT 'Tuesday', '15:00:00', '16:00:00' UNION ALL
    SELECT 'Tuesday', '16:00:00', '17:00:00' UNION ALL

    SELECT 'Wednesday', '08:00:00', '09:00:00' UNION ALL
    SELECT 'Wednesday', '09:00:00', '10:00:00' UNION ALL
    SELECT 'Wednesday', '10:00:00', '11:00:00' UNION ALL
    SELECT 'Wednesday', '11:00:00', '12:00:00' UNION ALL
    SELECT 'Wednesday', '12:00:00', '13:00:00' UNION ALL
    SELECT 'Wednesday', '13:00:00', '14:00:00' UNION ALL
    SELECT 'Wednesday', '14:00:00', '15:00:00' UNION ALL
    SELECT 'Wednesday', '15:00:00', '16:00:00' UNION ALL
    SELECT 'Wednesday', '16:00:00', '17:00:00' UNION ALL

    SELECT 'Thursday', '08:00:00', '09:00:00' UNION ALL
    SELECT 'Thursday', '09:00:00', '10:00:00' UNION ALL
    SELECT 'Thursday', '10:00:00', '11:00:00' UNION ALL
    SELECT 'Thursday', '11:00:00', '12:00:00' UNION ALL
    SELECT 'Thursday', '12:00:00', '13:00:00' UNION ALL
    SELECT 'Thursday', '13:00:00', '14:00:00' UNION ALL
    SELECT 'Thursday', '14:00:00', '15:00:00' UNION ALL
    SELECT 'Thursday', '15:00:00', '16:00:00' UNION ALL
    SELECT 'Thursday', '16:00:00', '17:00:00' UNION ALL

    SELECT 'Friday', '08:00:00', '09:00:00' UNION ALL
    SELECT 'Friday', '09:00:00', '10:00:00' UNION ALL
    SELECT 'Friday', '10:00:00', '11:00:00' UNION ALL
    SELECT 'Friday', '11:00:00', '12:00:00' UNION ALL
    SELECT 'Friday', '12:00:00', '13:00:00' UNION ALL
    SELECT 'Friday', '13:00:00', '14:00:00' UNION ALL
    SELECT 'Friday', '14:00:00', '15:00:00' UNION ALL
    SELECT 'Friday', '15:00:00', '16:00:00' UNION ALL
    SELECT 'Friday', '16:00:00', '17:00:00'
  ) AS tmp
),

all_rooms AS (
  SELECT DISTINCT room FROM Timetable WHERE room LIKE 'CR%' OR room LIKE 'TR%'
),

all_batches AS (
  SELECT batch_code FROM Batches
),

room_availability AS (
  SELECT ts.day, ts.start_time, ts.end_time, r.room
  FROM time_slots ts
  CROSS JOIN all_rooms r
  WHERE NOT EXISTS (
    SELECT 1 FROM Timetable t
    WHERE t.day_of_week = ts.day
      AND t.room = r.room
      AND ts.start_time < t.end_time AND ts.end_time > t.start_time
  )
),

batch_availability AS (
  SELECT ts.day, ts.start_time, ts.end_time, b.batch_code
  FROM time_slots ts
  CROSS JOIN all_batches b
  WHERE NOT EXISTS (
    SELECT 1 FROM Timetable t
    WHERE t.day_of_week = ts.day
      AND t.batch_code = b.batch_code
      AND ts.start_time < t.end_time AND ts.end_time > t.start_time
  )
)

SELECT 
  ts.day,
  ts.start_time,
  ts.end_time,
  COALESCE(GROUP_CONCAT(DISTINCT ra.room ORDER BY ra.room), 'None') AS available_rooms,
  COALESCE(GROUP_CONCAT(DISTINCT ba.batch_code ORDER BY ba.batch_code), 'None') AS available_batches
FROM time_slots ts
LEFT JOIN room_availability ra 
  ON ts.day = ra.day AND ts.start_time = ra.start_time AND ts.end_time = ra.end_time
LEFT JOIN batch_availability ba 
  ON ts.day = ba.day AND ts.start_time = ba.start_time AND ts.end_time = ba.end_time
GROUP BY ts.day, ts.start_time, ts.end_time
ORDER BY FIELD(ts.day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), ts.start_time;
