/*
DROP SCHEMA IF EXISTS LU_PG_MONITOR;
*/

/*
DROP TABLE IF EXISTS SECTION_B;
DROP TABLE IF EXISTS SECTION_C;
DROP TABLE IF EXISTS SECTION_D;
DROP TABLE IF EXISTS SECTION_E_SPVRS;
DROP TABLE IF EXISTS SECTION_E_CONVENOR;
DROP TABLE IF EXISTS SECTION_F;
DROP TABLE IF EXISTS REPORT_PROGRESS;
DROP TABLE IF EXISTS REPORT;
DROP TABLE IF EXISTS SCHOLARSHIP;
DROP TABLE IF EXISTS EMPLOYMENT;
DROP TABLE IF EXISTS SUPERVISION;
DROP TABLE IF EXISTS USER;
DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS DEPARTMENT;
*/

CREATE SCHEMA IF NOT EXISTS LU_PG_MONITOR;
USE LU_PG_MONITOR;

CREATE TABLE IF NOT EXISTS DEPARTMENT (
    dept_code VARCHAR(5) PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    faculty_code VARCHAR(5) NOT NULL,
    faculty_name VARCHAR(50) NOT NULL
);

INSERT INTO DEPARTMENT (dept_code, dept_name, faculty_code, faculty_name)
VALUES 
('DEM', 'Department of Environmental Management', 'ESD', 'Faculty of Environment, Society and Design'),
('DTSS', 'Department of Tourism, Sport and Society', 'ESD', 'Faculty of Environment, Society and Design'),
('SOLA', 'School of Landscape Architecture', 'ESD', 'Faculty of Environment, Society and Design');


CREATE TABLE IF NOT EXISTS STAFF (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    lname VARCHAR(50) NOT NULL,
    fname VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    employment_start_date DATE,
    employment_end_date DATE,
    room VARCHAR(200) NOT NULL,
    email_lu VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    dept_code VARCHAR(5),
    FOREIGN KEY (dept_code) REFERENCES DEPARTMENT(dept_code)
);

INSERT INTO STAFF (lname, fname, role, employment_start_date, room, email_lu, phone, dept_code)
VALUES 
('Anthony', 'Patricia', 'Postgraduate Chair', '2011-01-01', 'Landscape 031', 'yu-tzu.chang@lincolnuni.ac.nz', '98846260226', NULL),
('Holyoake', 'Andrew', 'Postgraduate Director', '2003-01-01', 'Landscape 123', 'andrew.holyoake@lincoln.ac.nz', '56322064554', NULL),
('Broughton', 'Douglas', 'Postgraduate Administrator', '2015-01-01', 'Landscape 123', 'bree.he@lincolnuni.ac.nz', '67472923655', NULL),
('Joe', 'John', 'Convenor', '2020-01-01','Room 101', 'na.bian@lincolnuni.ac.nz', '1234567890', 'DEM'),
('Smith', 'Jane', 'Convenor', '2018-07-01', 'Room 202', 'janesmith@lincoln.ac.nz', '0987654321', 'DTSS'),
('Johnson', 'David', 'Convenor', '2021-09-01', 'Room 303', 'davidjohnson@lincoln.ac.nz', '9876543210', 'SOLA'),
('Jones', 'Mary', 'Supervisor', '2019-02-01', 'Room 404', 'yao.su@lincolnuni.ac.nz', '3456789012', 'SOLA'),
('Lee', 'Mike', 'Supervisor', '2017-05-01', 'Room 505', 'mikelee@lincoln.ac.nz', '2345678901', 'DTSS'),
('Nguyen', 'Hieu', 'Supervisor', '2022-01-01', 'Room 606', 'hieunguyen@lincoln.ac.nz', '4567890123', 'DEM'),
('Brown', 'Chris', 'Supervisor', '2021-03-01', 'Room 707', 'chrisbrown@lincoln.ac.nz', '3456789012', 'DEM'),
('Kim', 'Jin', 'Supervisor', '2018-06-01', 'Room 808', 'jinkim@lincoln.ac.nz', '2345678901', 'DTSS'),
('Garcia', 'Maria', 'Supervisor', '2020-11-01', 'Room 909', 'mariagarcia@lincoln.ac.nz', '4567890123', 'SOLA'),
('Johnson', 'Sarah', 'Supervisor', '2017-09-01', 'Room 1010', 'sarahjohnson@lincoln.ac.nz', '7890123456', 'DEM'),
('Wu', 'Yan', 'Supervisor', '2019-05-01', 'Room 1111', 'yanwu@lincoln.ac.nz', '8901234567', 'DTSS'),
('Gupta', 'Raj', 'Supervisor', '2016-08-01', 'Room 1212', 'rajgupta@lincoln.ac.nz', '9012345678', 'SOLA');


CREATE TABLE IF NOT EXISTS STUDENT (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    lname VARCHAR(50) NOT NULL,
    fname VARCHAR(50) NOT NULL,
    enrollment_date DATE NOT NULL,
    current_address VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email_lu VARCHAR(50) NOT NULL UNIQUE,
    email_other VARCHAR(50) NOT NULL,
    part_full_time ENUM('Part time', 'Full time') NOT NULL,
    dept_code VARCHAR(5) NOT NULL,
    thesis_title VARCHAR(200) NOT NULL,
    FOREIGN KEY (dept_code) REFERENCES DEPARTMENT(dept_code)
);

INSERT INTO STUDENT (lname, fname, enrollment_date, current_address, phone, email_lu, email_other, part_full_time, dept_code, thesis_title)
VALUES
('Doe', 'John', '2021-01-15', '123 Main St, Anytown, NZ', '0214758593', 'frank.niu@lincolnuni.ac.nz', 'johndoe@gmail.com', 'Full time', 'DEM', 'Theis Title 1'),
('Smith', 'Jane', '2021-01-15', '456 Maple St, Anytown, NZ', '022475475', 'janesmith@lincoln.ac.nz', 'janesmith@yahoo.com', 'Part time', 'SOLA', 'Theis Title 2'),
('Nguyen', 'Hoa', '2021-02-01', '789 Oak St, Anytown, NZ', '0213698745', 'hoanguyen@lincoln.ac.nz', 'hoanguyen@yahoo.com', 'Full time', 'DEM', 'Theis Title 3'),
('Lee', 'Soo-Jin', '2021-02-01', '234 Elm St, Anytown, NZ', '0271234567', 'soojinlee@lincoln.ac.nz', 'soojinlee@hotmail.com', 'Part time', 'DTSS', 'Theis Title 4'),
('Wilson', 'Mark', '2021-02-01', '345 Pine St, Anytown, NZ', '0219876543', 'markwilson@lincoln.ac.nz', 'mwilson@gmail.com', 'Full time', 'SOLA', 'Theis Title 5'),
('Chen', 'Yun', '2021-03-01', '567 Birch St, Anytown, NZ', '0279876543', 'yunchen@lincoln.ac.nz', 'yunchen@hotmail.com', 'Part time', 'DTSS', 'Theis Title 6'),
('Smith', 'Tom', '2021-03-01', '789 Cedar St, Anytown, NZ', '0217894561', 'tomsmith@lincoln.ac.nz', 'tomsmith@gmail.com', 'Full time', 'SOLA', 'Theis Title 7'),
('Takahashi', 'Ryota', '2021-04-01', '890 Ash St, Anytown, NZ', '0271112222', 'ryotatakahashi@lincoln.ac.nz', 'ryotatakahashi@yahoo.co.jp', 'Part time', 'SOLA', 'Theis Title 8'),
('Kim', 'Min-Jae', '2021-04-01', '123 Walnut St, Anytown, NZ', '0229876543', 'minjaekim@lincoln.ac.nz', 'minjaekim@gmail.com', 'Full time', 'DTSS', 'Theis Title 9'),
('Smith', 'Lisa', '2021-05-01', '456 Oak St, Anytown, NZ', '0273698521', 'lisasmith@lincoln.ac.nz', 'lisa_smith@yahoo.com', 'Part time', 'SOLA', 'Theis Title 10'),
('Gupta', 'Rajesh', '2021-05-01', '567 Elm St, Anytown, NZ', '0211112222', 'rajeshgupta@lincoln.ac.nz', 'rajeshgupta@gmail.com', 'Full time', 'DEM', 'Theis Title 11'),
('Jones', 'Michael', '2021-06-01', '789 Pine St, Anytown, NZ', '0225556666', 'michaeljones@lincoln.ac.nz', 'mike_jones@yahoo.com', 'Part time', 'DTSS', 'Theis Title 12');


CREATE TABLE IF NOT EXISTS USER (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email_lu VARCHAR(50) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    admin_flag BOOLEAN NOT NULL
);

DROP TRIGGER IF EXISTS trg_user_email_lu;

DELIMITER //
CREATE TRIGGER trg_user_email_lu
BEFORE INSERT ON USER
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM STAFF WHERE email_lu = NEW.email_lu
        UNION ALL
        SELECT 1 FROM STUDENT WHERE email_lu = NEW.email_lu
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email_lu value';
    END IF;
END//
DELIMITER ;

INSERT INTO USER (email_lu, role, password, admin_flag)
VALUES 
('yu-tzu.chang@lincolnuni.ac.nz', 'Postgraduate Chair', '$2b$12$PCZm4l5T9LB8JVT6MRwn2.xeOVHksK/PEbljg1q9KymofkJCTaN86', 1),
('andrew.holyoake@lincoln.ac.nz', 'Postgraduate Director', '$2b$12$vs/OZ/wRWPrgy.f4UZryWukyXbNXMRn0FROMUHL2smw9V9nkeFHMK', 1),
('bree.he@lincolnuni.ac.nz', 'Postgraduate Administrator', '$2b$12$o0ADyYFuuZGaB7x9jn6IfedfJO7IbvG.SiQuIBAjjoZ/LIN1rfocu', 1),
('davidjohnson@lincoln.ac.nz', 'Convenor', '$2b$12$G23d4FjZnczJ1pjRe3uiOeK7uv3xAMV050W9qZrlApqLX.99GyRi.', 1),
('na.bian@lincolnuni.ac.nz', 'Convenor', '$2b$12$TX/ae0Zp1DvEjEZT4w6HHu6Xyn1HDge0o6DW71GAFGuSeBQ/S8J8O', 1),
('yao.su@lincolnuni.ac.nz', 'Supervisor', '$2b$12$PjwRidUlOZx1xhRoR5pxo.5/bnzLu0X3WrqZVUm6Ds8H7.hln87tq', 1),
('frank.niu@lincolnuni.ac.nz', 'Student', '$2b$12$CsZ75vIrrjTiDxMvuwmvUOZwHEz8xcAlZqrd/FiQu8YMh7xZdEInG', 1),
('janesmith@lincoln.ac.nz', 'Student', '$2b$12$mm/cIfL9wulQJa0etuqSwOqtknzGUtT75OhpCO/o6ZPtaGvnCpwfS', 1),
('mikelee@lincoln.ac.nz','Supervisor','$2b$12$0PBObjx4l5nBXe4wmtWbuuawXxr8e7raLCPFslhAaDQx4A6ENLCDa',1),
('sarahjohnson@lincoln.ac.nz','Supervisor','$2b$12$UWWBbeujGxYtiz1JIe6Q5OB0DXl6ERkQVvYD7CvkRVjs8uefUcL4a',1),
('rajgupta@lincoln.ac.nz','Supervisor','$2b$12$oY4fo7b.XJeGllwZkmQslePrbAzneQQdyZrn.o/9dV5nr48GlZKeC',0)
;


CREATE TABLE IF NOT EXISTS SUPERVISION (
    supervision_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    staff_id INT NOT NULL,
    supv_type ENUM('Main Supervisor', 'Associate Supervisor', 'Other Supervisor') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
);

INSERT INTO SUPERVISION (student_id, staff_id, supv_type) VALUES
(1, 7, 'Main Supervisor'),
(1, 8, 'Associate Supervisor'),
(1, 13, 'Other Supervisor'),
(1, 15, 'Other Supervisor'),
(2, 9, 'Main Supervisor'),
(2, 10, 'Associate Supervisor'),
(2, 11, 'Other Supervisor'),
(2, 14, 'Other Supervisor'),
(2, 15, 'Other Supervisor'),
(3, 8, 'Main Supervisor'),
(3, 11, 'Associate Supervisor'),
(4, 9, 'Main Supervisor'),
(4, 10, 'Associate Supervisor'),
(4, 7, 'Other Supervisor'),
(5, 9, 'Main Supervisor'),
(6, 7, 'Main Supervisor'),
(6, 8, 'Associate Supervisor'),
(7, 9, 'Main Supervisor'),
(7, 12, 'Associate Supervisor'),
(8, 10, 'Main Supervisor'),
(8, 8, 'Associate Supervisor'),
(9, 11, 'Main Supervisor'),
(9, 9, 'Associate Supervisor'),
(10, 12, 'Main Supervisor'),
(10, 10, 'Associate Supervisor'),
(11, 12, 'Main Supervisor'),
(11, 15, 'Associate Supervisor'),
(12, 12, 'Main Supervisor'),
(12, 15, 'Associate Supervisor')
;


CREATE TABLE IF NOT EXISTS SCHOLARSHIP (
    sola_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    scholarship_name VARCHAR(50) NOT NULL,
    scholarship_value DECIMAL(10, 2) NOT NULL,
    scholarship_tenure VARCHAR(100) NOT NULL,
    scholarship_start_date DATE NOT NULL,
    scholarship_end_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id)
);

INSERT INTO SCHOLARSHIP (student_id, scholarship_name, scholarship_value, scholarship_tenure, scholarship_start_date, scholarship_end_date) 
VALUES
(1, 'Merit Scholarship', 5000.00, 'One academic year', '2021-05-01', '2022-04-30'),
(1, 'Need-Based Scholarship', 2500.00, 'One semester', '2022-05-01', '2023-08-15'),
(2, 'Athletic Scholarship', 7500.00, 'Full four-year program', '2020-06-01', '2024-05-31'),
(3, 'STEM Scholarship', 10000.00, 'Two academic years', '2021-08-01', '2023-05-31'),
(3, 'Music Scholarship', 3500.00, 'One academic year', '2023-06-01', '2024-05-31'),
(3, 'Community Service Scholarship', 5000.00, 'One semester', '2023-01-01', '2023-05-15'),
(3, 'Research Scholarship', 6000.00, 'Summer program', '2022-11-21', '2023-01-31'),
(4, 'STEM Scholarship', 10000.00, 'Two academic years', '2022-08-01', '2024-05-31'),
(5, 'Community Service Scholarship', 2000.00, 'One academic year', '2023-08-01', '2024-05-31'),
(6, 'Fine Arts Scholarship', 5000.00, 'One academic year', '2023-08-01', '2024-05-31'),
(7, 'International Student Scholarship', 7500.00, 'One academic year', '2022-08-01', '2023-05-31'),
(8, 'Underrepresented Minority Scholarship', 3000.00, 'One academic year', '2023-08-01', '2024-05-31'),
(9, 'Military Service Scholarship', 10000.00, 'Full four-year program', '2020-08-01', '2024-05-31'),
(10, 'Research Fellowship', 5000.00, 'One academic year', '2022-08-01', '2023-05-31'),
(11, 'Entrepreneurship Scholarship', 5000.00, 'One academic year', '2023-08-01', '2024-05-31'),
(12, 'Research Scholarship', 6000.00, 'Summer program', '2022-11-21', '2023-01-31')
;


CREATE TABLE IF NOT EXISTS EMPLOYMENT (
    empt_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    company_name VARCHAR(50) NOT NULL,
    employment_start_date DATE NOT NULL,
    employment_end_date DATE,
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id)
);

INSERT INTO EMPLOYMENT (student_id, company_name, employment_start_date, employment_end_date) 
VALUES
(1, 'ABC Company', '2021-06-01', '2022-05-31'),
(1, 'XYZ Corporation', '2022-01-15', NULL),
(2, '123 Industries', '2021-09-01', '2022-05-31'),
(2, 'DEF Corporation', '2021-08-15', '2022-08-14'),
(2, 'Acme Inc.', '2023-02-01', NULL),
(3, 'DEF Corporation', '2021-08-15', '2022-08-14'),
(3, 'GHI Enterprises', '2022-06-01', '2022-12-31'),
(3, '456 Solutions', '2022-01-01', '2022-06-30'),
(4, 'JKL Corporation', '2023-05-01', NULL),
(5, '789 Industries', '2022-03-01', '2022-08-31'),
(6, 'MNO Corporation', '2021-11-01', '2022-05-31')
;


CREATE TABLE IF NOT EXISTS REPORT (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    rept_year YEAR NOT NULL,  
    rept_term ENUM('JUNE', 'DEC') NOT NULL,
    due_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id)
);

INSERT INTO REPORT (student_id, rept_year, rept_term, due_date)
VALUES
(1, 2022, 'DEC', '2022-12-31'),
(2, 2022, 'DEC', '2022-12-31'),
(3, 2022, 'DEC', '2022-12-31'),
(1, 2023, 'JUNE', '2023-06-30'),
(2, 2023, 'JUNE', '2023-06-30'),
(3, 2023, 'JUNE', '2023-06-30')
;


CREATE TABLE IF NOT EXISTS REPORT_PROGRESS (
    report_id INT PRIMARY KEY,
    student_abcd_completed BOOLEAN,
    student_f_completed BOOLEAN,
    supervisors_completed INT,
    convenor_completed BOOLEAN,
    full_report_completed BOOLEAN,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);

INSERT INTO REPORT_PROGRESS (report_id, student_abcd_completed, student_f_completed, supervisors_completed, convenor_completed, full_report_completed)
VALUES
(1, 1, 0, 4, 1, 1),
(2, 1, 0, 5, 1, 1),
(3, 1, 0, 2, 1, 1),
(4, 0, 0, 0, 0, 0),
(5, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 0, 0)
;


CREATE TABLE IF NOT EXISTS SECTION_B (
    report_id INT PRIMARY KEY,
    inducion_completed_date DATE,
    mutual_expec_completed_date DATE,
    kaupapa_completed_date DATE,
    intellectual_prop_completed_date DATE,
    thesis_prop_completed_date DATE,
    research_prop_completed_date DATE,
    lu_pg_conference_completed_date DATE,
    thesis_result_completed_date DATE,
    human_ethics ENUM('Needed', 'Approved', 'Not Needed') NOT NULL,
    health_and_safety ENUM('Needed', 'Approved', 'Not Needed') NOT NULL,
    animal_ethics ENUM('Needed', 'Approved', 'Not Needed') NOT NULL,
    insti_bio_safety ENUM('Needed', 'Approved', 'Not Needed') NOT NULL,
    radiation_protection ENUM('Needed', 'Approved', 'Not Needed') NOT NULL,
    reporting_box ENUM('1', '2', '3','4', '5', '6') NOT NULL,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);


CREATE TABLE IF NOT EXISTS SECTION_C (
    report_id INT PRIMARY KEY,
    access_principal ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    access_principal_comment TEXT,
    access_asst_other ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    access_asst_other_comment TEXT,
    expertise_principal ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    expertise_principal_comment TEXT,
    expertise_asst_other ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    expertise_asst_other_comment TEXT,
    quality_principal ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    quality_principal_comment TEXT,
    quality_asst_other ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    quality_asst_other_comment TEXT,
    timeless_principal ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    timeless_principal_comment TEXT,
    timeless_asst_other ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    timelessy_asst_other_comment TEXT,
    courses_available ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    courses_available_comment TEXT,
    workspace ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    workspace_comment TEXT,
    computer_facilities ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    computer_faci_comment TEXT,
    its_supt ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    its_supt_comment TEXT,
    research_software ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    research_software_comment TEXT,
    library_facilities ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    library_faci_comment TEXT,
    teach_Learn_supt ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    teach_Learn_supt_comment TEXT,
    statistical_supt ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    statistical_supt_comment TEXT,
    research_equip ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    research_equip_comment TEXT,
    technical_supt ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    technical_supt_comment TEXT,
    financial_resource ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    financial_resource_comment TEXT,
    other ENUM('Very Good', 'Good', 'Satisfactory','Unsatisfactory', 'Not Relevant') NOT NULL,
    other_comment TEXT,
    meeting_frequency ENUM('Weekly', 'Fortnightly', 'Monthly','Every 3 months', 'Half yearly', 'Not at all') NOT NULL,
    feedback_period ENUM('1 week', '2 weeks', '1 month', '3months') NOT NULL,
    feedback_type TEXT NOT NULL,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);


CREATE TABLE IF NOT EXISTS SECTION_D (
    report_id INT PRIMARY KEY,
    t1 JSON NOT NULL,
    t1_comment TEXT,
    t2 JSON NOT NULL,
    t3 JSON NOT NULL,
    t4 JSON NOT NULL,
    t5 JSON NOT NULL,
    t5_comment TEXT NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);


CREATE TABLE IF NOT EXISTS SECTION_E_SPVRS (
    report_id INT NOT NULL,
    student_name VARCHAR(50) NOT NULL, -- can be removed
    student_id INT NOT NULL, -- can be removed
    spvr_name VARCHAR(50) NOT NULL, -- can be removed
    staff_id INT NOT NULL,
    supv_type ENUM('Main Supervisor', 'Associate Supervisor', 'Other Supervisor') NOT NULL,
    overall_6m ENUM('Excellent', 'Good', 'Satisfactory','Below Average', 'Unsatisfactory') NOT NULL,
    overall_full ENUM('Excellent', 'Good', 'Satisfactory','Below Average', 'Unsatisfactory') NOT NULL,
    work_quality ENUM('Excellent', 'Good', 'Satisfactory','Below Average', 'Unsatisfactory') NOT NULL,
    technical_skill ENUM('Excellent', 'Good', 'Satisfactory','Below Average', 'Unsatisfactory') NOT NULL,
    likelihood_6m ENUM('Excellent', 'Good', 'Satisfactory','Below Average', 'Unsatisfactory') NOT NULL,
    recommendation ENUM('Yes', 'No', 'N/A'),
    comments TEXT NOT NULL,
    date DATE NOT NULL,
    sectione_s_id INT AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);


 CREATE TABLE IF NOT EXISTS SECTION_E_CONVENOR (
    report_id INT NOT NULL,
    staff_id INT NOT NULL,
    convenor_name VARCHAR(50) NOT NULL,
    comments TEXT NOT NULL,
    date DATE NOT NULL,
    student_status ENUM('G', 'O', 'R') NOT NULL,
    sectione_c_id INT AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);	

INSERT INTO SECTION_E_CONVENOR (report_id, staff_id, convenor_name, comments, date, student_status, sectione_c_id)
VALUES
(1, 4, 'Joe John', 'Improvements required.', '2022-11-09', 'O', 1),
(2, 6, 'Johnson David', 'Excellent.', '2022-11-09', 'G', 2),
(3, 4, 'Joe John', 'Signficant improvements required.', '2022-11-09', 'R', 3),
(4, 4, 'Joe Hohn', 'Improvements required.', '2023-05-10', 'O', 4),
(5, 6, 'Johnson David', 'Signficant improvements required.', '2023-05-10', 'R', 5),
(6, 4, 'Joe Hohn', 'Good.', '2023-05-10', 'G', 6);


CREATE TABLE IF NOT EXISTS SECTION_F (
    report_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    spvrs_names VARCHAR(200),
    comments TEXT,
    talk_to ENUM('PG Chair', 'Convenor'),
    date DATE NOT NULL,
    FOREIGN KEY (report_id) REFERENCES REPORT(report_id)
);
