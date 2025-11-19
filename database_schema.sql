-- Database Schema based on ERD Diagram
-- Digital Logic Design Problem - Solved Implementation

-- Table: ΧΡΗΣΤΗΣ (User)
CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    όνομα VARCHAR(100),
    θέση VARCHAR(100),
    τηλ_επικοινωνίας VARCHAR(20)
);

-- Table: ΧΩΡΟΣ_ΕΡΓΑΣΙΑΣ (Workspace)
CREATE TABLE workspaces (
    κωδικός_ΧΩΡΟΥ VARCHAR(50) PRIMARY KEY,
    τίτλος VARCHAR(200) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ_ΔΗΜΙΟΥΡΓΙΑΣ TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: ΑΝΤΙΚΕΙΜΕΝΟ (Object)
CREATE TABLE objects (
    ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ VARCHAR(50) PRIMARY KEY,
    ΤΥΠΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ VARCHAR(50),
    κωδικός VARCHAR(50),
    τίτλος VARCHAR(200),
    θέση VARCHAR(100),
    ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ TIMESTAMP
);

-- Table: ΓΝΩΣΙΑΚΟ_ΑΝΤΙΚΕΙΜΕΝΟ (Knowledge Object)
CREATE TABLE knowledge_objects (
    id SERIAL PRIMARY KEY,
    blob BYTEA,
    κείμενο TEXT
);

-- Table: ΦΑΚΕΛΟΣ (Folder)
CREATE TABLE folders (
    id SERIAL PRIMARY KEY,
    όνομα VARCHAR(200)
);

-- Table: ΣΥΝΤΟΜΕΥΣΗ (Shortcut)
CREATE TABLE shortcuts (
    id SERIAL PRIMARY KEY
);

-- Table: ΛΥΣΗ (Solution)
CREATE TABLE solutions (
    id SERIAL PRIMARY KEY,
    ΕΠΙΠΕΔΟ_ΣΙΓΟΥΡΙΑΣ VARCHAR(50)
);

-- Table: ΠΡΟΒΛΗΜΑ (Problem)
CREATE TABLE problems (
    id SERIAL PRIMARY KEY
);

-- Table: ΕΠΙΧΕΙΡΗΜΑ (Operation)
CREATE TABLE operations (
    id SERIAL PRIMARY KEY,
    ΤΥΠΟΣ_ΕΠΙΧΕΙΡΗΜΑΤΟΣ VARCHAR(50),
    ΒΑΘΜΟΣ_ΣΗΜΑΝΤΙΚΟΤΗΤΑΣ VARCHAR(50)
);

-- Table: ΧΡΗΣΤΕΣ (Users - Many-to-Many relationship table)
CREATE TABLE workspace_users (
    username VARCHAR(50) REFERENCES users(username),
    κωδικός_ΧΩΡΟΥ VARCHAR(50) REFERENCES workspaces(κωδικός_ΧΩΡΟΥ),
    PRIMARY KEY (username, κωδικός_ΧΩΡΟΥ)
);

-- Table: ΑΝΑΦΟΡΑ (Report)
CREATE TABLE reports (
    ΑΡΙΘΜΟΣ SERIAL PRIMARY KEY,
    URL VARCHAR(500),
    ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ TIMESTAMP,
    ΑΠΟΤΕΛΕΣΜΑ TEXT
);

-- Relationship Tables

-- ΧΡΗΣΤΗΣ ΔΗΜΙΟΥΓΕΙ ΧΩΡΟΣ_ΕΡΓΑΣΙΑΣ
CREATE TABLE user_creates_workspace (
    username VARCHAR(50) REFERENCES users(username),
    κωδικός_ΧΩΡΟΥ VARCHAR(50) REFERENCES workspaces(κωδικός_ΧΩΡΟΥ),
    PRIMARY KEY (username, κωδικός_ΧΩΡΟΥ)
);

-- ΧΩΡΟΣ_ΕΡΓΑΣΙΑΣ ΠΕΡΙΕΧΕΙ ΑΝΤΙΚΕΙΜΕΝΟ
CREATE TABLE workspace_contains_object (
    κωδικός_ΧΩΡΟΥ VARCHAR(50) REFERENCES workspaces(κωδικός_ΧΩΡΟΥ),
    ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ VARCHAR(50) REFERENCES objects(ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ),
    PRIMARY KEY (κωδικός_ΧΩΡΟΥ, ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ)
);

-- ΑΝΤΙΚΕΙΜΕΝΟ ΣΧΕΤΙΖΕΤΑΙ με άλλα ΑΝΤΙΚΕΙΜΕΝΑ
CREATE TABLE object_relationships (
    object1_id VARCHAR(50) REFERENCES objects(ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ),
    object2_id VARCHAR(50) REFERENCES objects(ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ),
    PRIMARY KEY (object1_id, object2_id)
);

-- ΑΝΤΙΚΕΙΜΕΝΟ ΦΤΙΑΧΝΟΥΝ ΧΡΗΣΤΕΣ
CREATE TABLE users_create_objects (
    username VARCHAR(50) REFERENCES users(username),
    ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ VARCHAR(50) REFERENCES objects(ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ),
    PRIMARY KEY (username, ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ)
);

-- ΦΑΚΕΛΟΣ ΠΕΡΙΛΑΜΒΑΝΕΙ ΑΝΤΙΚΕΙΜΕΝΟ
CREATE TABLE folder_contains_object (
    folder_id INTEGER REFERENCES folders(id),
    ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ VARCHAR(50) REFERENCES objects(ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ),
    PRIMARY KEY (folder_id, ΚΩΔΙΚΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ)
);

-- ΕΠΙΧΕΙΡΗΜΑ ΣΥΝΔΕΕΤΑΙ_1 με ΛΥΣΗ
CREATE TABLE operation_connects_solution_1 (
    operation_id INTEGER REFERENCES operations(id),
    solution_id INTEGER REFERENCES solutions(id),
    PRIMARY KEY (operation_id, solution_id)
);

-- ΕΠΙΧΕΙΡΗΜΑ ΣΥΝΔΕΕΤΑΙ_2 με ΠΡΟΒΛΗΜΑ
CREATE TABLE operation_connects_problem_2 (
    operation_id INTEGER REFERENCES operations(id),
    problem_id INTEGER REFERENCES problems(id),
    PRIMARY KEY (operation_id, problem_id)
);

-- ΧΡΗΣΤΗΣ ΑΞΙΟΛΟΓΕΙ ΑΝΑΦΟΡΑ
CREATE TABLE user_evaluates_report (
    username VARCHAR(50) REFERENCES users(username),
    ΑΡΙΘΜΟΣ INTEGER REFERENCES reports(ΑΡΙΘΜΟΣ),
    PRIMARY KEY (username, ΑΡΙΘΜΟΣ)
);

-- ΑΝΑΦΟΡΑ ΑΝΤΙΣΤΟΙΧΙΖΕΤΑΙ με ΧΩΡΟΣ_ΕΡΓΑΣΙΑΣ
CREATE TABLE report_corresponds_workspace (
    ΑΡΙΘΜΟΣ INTEGER REFERENCES reports(ΑΡΙΘΜΟΣ),
    κωδικός_ΧΩΡΟΥ VARCHAR(50) REFERENCES workspaces(κωδικός_ΧΩΡΟΥ),
    PRIMARY KEY (ΑΡΙΘΜΟΣ, κωδικός_ΧΩΡΟΥ)
);

-- Indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_workspaces_title ON workspaces(τίτλος);
CREATE INDEX idx_objects_type ON objects(ΤΥΠΟΣ_ΑΝΤΙΚΕΙΜΕΝΟΥ);
CREATE INDEX idx_operations_type ON operations(ΤΥΠΟΣ_ΕΠΙΧΕΙΡΗΜΑΤΟΣ);
