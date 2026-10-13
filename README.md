# EventSphere: Conference & Event Registration System

**Case Study 74** | DBMS Final Project
**Author:** Mohammed Saad Mulla | Roll No: 150096725112 | B.Tech 2025-2029

EventSphere is a relational database for managing multi-session conferences. Attendees register for individual sessions inside an event, and the database guarantees that the **same attendee can never be registered for the same session twice**. Organisers can also see how many people are registered per session and per event, for room and catering planning.

---

## Files

| File | What it contains |
|------|------------------|
| `EventSphere.sql` | The full database in one script: table definitions, seed data, and 5 queries |
| `DBMS_FINAL_SAAD.pdf` | The project report: entities, schema, normalisation, queries, ER diagram (page 6), and DBMS theory |

---

## Database Design

Five tables, all linked by 1:M relationships:

```
events ──1:M──> sessions <──M:1── speakers
                   │
                  1:M
                   ▼
              registrations <──M:1── attendees
```

| Table | Purpose |
|-------|---------|
| `events` | The conference itself (e.g. TechConf 2026) |
| `speakers` | Speaker name and bio, stored once (the 2NF fix) |
| `sessions` | One talk or slot, linked to an event and a speaker |
| `attendees` | People who register |
| `registrations` | Bridge table linking attendees to sessions |

### Key design decisions

- **M:N resolved with a bridge table.** Attendee and Session are many-to-many, so `registrations` sits between them and turns it into two clean 1:M relationships.
- **Normalisation (2NF).** Speaker name and bio were originally repeated on every session row. They now live in their own `speakers` table, linked by `speaker_id`.
- **UNIQUE constraint.** `UNIQUE (attendee_id, session_id)` on `registrations` makes duplicate registrations impossible. The database itself rejects them.

---

## Seed Data

- 3 events: TechConf 2026, AI Summit 2026, DevFest 2026
- 6 speakers
- 8 sessions
- 10 attendees
- 30 registrations, with no repeated (attendee, session) pair

Aarav Shah (attendee 1) is registered for 4 sessions on purpose, so the "busy attendees" query returns a row during a demo.

---

## How to Run

1. Open your SQL client (MySQL Workbench, command line, etc.).
2. Run the whole script:

   ```bash
   mysql -u <user> -p <database_name> < EventSphere.sql
   ```

   or paste the contents of `EventSphere.sql` into your client and execute.

The script starts with `DROP TABLE IF EXISTS ...`, so it is safe to re-run. It rebuilds everything from scratch.

---

## Queries Included

| # | What it does | Concepts shown |
|---|--------------|----------------|
| 1 | Attendee count for each session | `LEFT JOIN`, `GROUP BY`, `COUNT` |
| 2 | Each speaker's full session schedule | `JOIN`, multi-column `ORDER BY` |
| 3 | Full registration detail (attendee, event, session) in one row | 3-table `JOIN`, referential integrity |
| 4 | Total registrations per event | `JOIN` + `LEFT JOIN`, aggregation |
| 5 | Attendees registered for more than 3 sessions | `GROUP BY`, `HAVING` |

---

## Demo: Proving the UNIQUE Constraint

At the bottom of `EventSphere.sql` there is a commented-out `INSERT`:

```sql
INSERT INTO registrations (registration_id, attendee_id, session_id, registration_time)
VALUES (31, 1, 1, '2026-11-05 09:00:00');
```

Uncomment and run it. Attendee 1 is already registered for session 1, so it fails with:

```
ERROR 1062 (23000): Duplicate entry '1-1' for key 'registrations.uq_attendee_session'
```

The `registration_id` is 31 because it is unused. An id that already exists would fail on the primary key first and demonstrate the wrong thing.

---

## ER Diagram

See page 6 of `DBMS_FINAL_SAAD.pdf` (section 7.1). Every connector is labelled 1:M. There is no direct M:N line, because it is resolved through the `registrations` bridge table.
