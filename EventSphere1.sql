-- Project : EventSphere (Conference & Event Registration Management)

DROP TABLE IF EXISTS registrations, sessions, attendees, speakers, events CASCADE;

-- Entity: Event

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    venue VARCHAR(100) NOT NULL
);

-- Entity: Speaker (separated out to remove repeated name/bio - 2NF)

CREATE TABLE speakers (
    speaker_id INT PRIMARY KEY,
    speaker_name VARCHAR(100) NOT NULL,
    bio VARCHAR(300)
);

-- Entity: Session
-- One event -> many sessions (1:M)
-- One speaker -> many sessions (1:M, from the speaker's side)

CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    event_id INT NOT NULL,
    speaker_id INT NOT NULL,
    session_name VARCHAR(150) NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room VARCHAR(50) NOT NULL,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (speaker_id) REFERENCES speakers(speaker_id)
);

-- Entity: Attendee

CREATE TABLE attendees (
    attendee_id INT PRIMARY KEY,
    attendee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20)
);

-- Entity: Registration (the bridge table for the M:N relationship
-- between Attendee and Session)
--
-- UNIQUE (attendee_id, session_id) is the advanced-concept constraint:
-- it makes it IMPOSSIBLE for the same attendee to register for the
-- same session twice.

CREATE TABLE registrations (
    registration_id INT PRIMARY KEY,
    attendee_id INT NOT NULL,
    session_id INT NOT NULL,
    registration_time TIMESTAMP NOT NULL,
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    CONSTRAINT uq_attendee_session UNIQUE (attendee_id, session_id)
);

-- SEED DATA: 3 EVENTS

INSERT INTO events (event_id, event_name, event_date, venue) VALUES
(1, 'TechConf 2026', '2026-11-10', 'Mumbai Convention Center'),
(2, 'AI Summit 2026', '2026-11-15', 'Bengaluru Tech Park'),
(3, 'DevFest 2026', '2026-11-20', 'Pune Expo Hall');

-- SEED DATA: 6 SPEAKERS

INSERT INTO speakers (speaker_id, speaker_name, bio) VALUES
(1, 'Dr. Ananya Rao', 'AI researcher focused on generative models and ethics'),
(2, 'Karthik Subramanian', 'Cloud architect specializing in distributed systems'),
(3, 'Fatima Sheikh', 'Cybersecurity expert working on AI-era threat detection'),
(4, 'Rohan Deshmukh', 'Full-stack engineer and API design specialist'),
(5, 'Priya Chandran', 'Data scientist with a focus on applied ML in industry'),
(6, 'Arjun Mehta', 'Product manager bridging engineering and user experience');

-- SEED DATA: 8 SESSIONS (spread across the 3 events)

INSERT INTO sessions
(session_id, event_id, speaker_id, session_name, session_date, start_time, end_time, room) VALUES
(1, 1, 1, 'AI Ethics Panel', '2026-11-10', '10:00:00', '11:00:00', 'Hall A'),
(2, 1, 2, 'Cloud Native Architectures', '2026-11-10', '11:30:00', '12:30:00', 'Hall B'),
(3, 1, 4, 'Building Scalable APIs', '2026-11-10', '14:00:00', '15:00:00', 'Hall A'),
(4, 2, 1, 'Future of Generative AI', '2026-11-15', '10:00:00', '11:00:00', 'Hall C'),
(5, 2, 5, 'Data Science in Practice', '2026-11-15', '11:30:00', '12:30:00', 'Hall C'),
(6, 2, 3, 'Cybersecurity in the AI Era', '2026-11-15', '14:00:00', '15:00:00', 'Hall D'),
(7, 3, 4, 'Modern DevOps Workflows', '2026-11-20', '10:00:00', '11:00:00', 'Hall E'),
(8, 3, 6, 'Product Thinking for Engineers', '2026-11-20', '11:30:00', '12:30:00', 'Hall E');

-- SEED DATA: 10 ATTENDEES

INSERT INTO attendees (attendee_id, attendee_name, email, phone) VALUES
(1, 'Aarav Shah', 'aarav.shah@mail.com', '9876500001'),
(2, 'Riya Kapoor', 'riya.kapoor@mail.com', '9876500002'),
(3, 'Kabir Joshi', 'kabir.joshi@mail.com', '9876500003'),
(4, 'Meera Nair', 'meera.nair@mail.com', '9876500004'),
(5, 'Dev Patel', 'dev.patel@mail.com', '9876500005'),
(6, 'Sara Khan', 'sara.khan@mail.com', '9876500006'),
(7, 'Ishaan Verma', 'ishaan.verma@mail.com', '9876500007'),
(8, 'Tara Singh', 'tara.singh@mail.com', '9876500008'),
(9, 'Neel Gupta', 'neel.gupta@mail.com', '9876500009'),
(10, 'Ananya Iyer', 'ananya.iyer@mail.com', '9876500010');

-- SEED DATA: 30 REGISTRATIONS
-- (Each attendee has registered for a few different sessions.
--  No (attendee_id, session_id) pair repeats - the UNIQUE
--  constraint would block that anyway.)

INSERT INTO registrations (registration_id, attendee_id, session_id, registration_time) VALUES
(1, 1, 1, '2026-11-01 09:00:00'),
(2, 2, 1, '2026-11-01 09:05:00'),
(3, 3, 1, '2026-11-01 09:10:00'),
(4, 4, 1, '2026-11-01 09:15:00'),
(5, 5, 1, '2026-11-01 09:20:00'),
(6, 1, 2, '2026-11-01 09:25:00'),
(7, 3, 2, '2026-11-01 09:30:00'),
(8, 6, 2, '2026-11-01 09:35:00'),
(9, 7, 2, '2026-11-01 09:40:00'),
(10, 2, 3, '2026-11-01 09:45:00'),
(11, 4, 3, '2026-11-01 09:50:00'),
(12, 8, 3, '2026-11-01 09:55:00'),
(13, 5, 4, '2026-11-02 10:00:00'),
(14, 6, 4, '2026-11-02 10:05:00'),
(15, 7, 4, '2026-11-02 10:10:00'),
(16, 9, 4, '2026-11-02 10:15:00'),
(17, 10, 4, '2026-11-02 10:20:00'),
(18, 1, 5, '2026-11-02 10:25:00'),
(19, 8, 5, '2026-11-02 10:30:00'),
(20, 9, 5, '2026-11-02 10:35:00'),
(21, 2, 6, '2026-11-02 10:40:00'),
(22, 5, 6, '2026-11-02 10:45:00'),
(23, 10, 6, '2026-11-02 10:50:00'),
(24, 3, 7, '2026-11-03 11:00:00'),
(25, 6, 7, '2026-11-03 11:05:00'),
(26, 9, 7, '2026-11-03 11:10:00'),
(27, 4, 8, '2026-11-03 11:15:00'),
(28, 7, 8, '2026-11-03 11:20:00'),
(29, 10, 8, '2026-11-03 11:25:00'),
(30, 1, 3, '2026-11-01 09:52:00');


-- ============================================================
-- QUERIES
-- ============================================================



-- QUERY 1:
-- Count the number of attendees registered for EACH session.

SELECT se.session_id,
       se.session_name,
       COUNT(r.registration_id) AS attendee_count
FROM sessions se
LEFT JOIN registrations r
    ON se.session_id = r.session_id
GROUP BY se.session_id, se.session_name
ORDER BY se.session_id;



-- QUERY 2 : each speaker's full session schedule


SELECT sp.speaker_name,
       se.session_name,
       se.session_date,
       se.start_time,
       se.end_time,
       se.room
FROM speakers sp
JOIN sessions se
    ON sp.speaker_id = se.speaker_id
ORDER BY sp.speaker_name, se.session_date, se.start_time;



-- QUERY 3: Full registration detail - attendee, session, and the
-- event that session belongs to, all in one row.
SELECT r.registration_id,
       a.attendee_name,
       ev.event_name,
       se.session_name,
       se.session_date,
       r.registration_time
FROM registrations r
JOIN attendees a
    ON r.attendee_id = a.attendee_id
JOIN sessions se
    ON r.session_id = se.session_id
JOIN events ev
    ON se.event_id = ev.event_id
ORDER BY ev.event_name, se.session_name, r.registration_time;



-- QUERY 4: attendance per event  --


SELECT ev.event_name,
       COUNT(r.registration_id) AS total_registrations
FROM events ev
JOIN sessions se
    ON ev.event_id = se.event_id
LEFT JOIN registrations r
    ON se.session_id = r.session_id
GROUP BY ev.event_id, ev.event_name
ORDER BY total_registrations DESC;



-- QUERY 5: Which attendees are registered for more than 3 sessions
-- (the "busy attendees" view)
SELECT a.attendee_name,
       COUNT(r.registration_id) AS sessions_registered
FROM attendees a
JOIN registrations r
    ON a.attendee_id = r.attendee_id
GROUP BY a.attendee_id, a.attendee_name
HAVING COUNT(r.registration_id) > 3
ORDER BY sessions_registered DESC;



-- DEMONSTRATION: the UNIQUE constraint 

-- INSERT INTO registrations (registration_id, attendee_id, session_id, registration_time)
-- VALUES (31, 1, 1, '2026-11-05 09:00:00');
