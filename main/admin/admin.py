from main import common
from flask import (Blueprint, Response, flash, redirect, render_template,
                   request, session, url_for)
from main.admin import admin_bp
from main.config import sendMail
from main.common import getCursor
from datetime import date

@admin_bp.route("/")
def index():
    username = session.get('username')
    return render_template("admin.html", username=username)

@admin_bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

@admin_bp.route("/studentlist", methods=["GET", "POST"])
def viewStudentList():
    query = """
                SELECT S.student_id, S.fname, S.lname, S.phone, S.email_lu, S.part_full_time, D.dept_name 
                FROM STUDENT S
                LEFT JOIN DEPARTMENT D ON S.dept_code = D.dept_code
                """
    
    if request.method != "GET":
        student_id = request.form.get('studentID')
        student_name = request.form.get('studentName')
        department_code = request.form.get('departmentCode')
        conditions = []

        if student_id is not None and student_id.isdigit():
            conditions.append(f"S.student_id = {student_id}")

        if student_name is not None and len(student_name.strip()) > 0:
            conditions.append(f"(S.fname LIKE '%{student_name}%' OR S.lname LIKE '%{student_name}%')")

        if department_code is not None and len(department_code.strip()) > 0:
            conditions.append(f"S.dept_code LIKE '%{department_code}%'")

        if conditions:
            query += " WHERE " + " OR ".join(conditions)

    connection = common.getCursor()
    connection.execute(query)
    studentList = connection.fetchall()
    return render_template("viewStudentList.html", studentList=studentList)

@admin_bp.route("/studentdetail/<int:student_id>", methods=["GET", "POST"])
def viewStudengDetail(student_id):
    query_profile = f"""
                SELECT S.student_id, S.fname, S.lname, S.enrollment_date, S.current_address, S.phone, S.email_lu, S.email_other, S.part_full_time, D.dept_name , S.thesis_title
                FROM STUDENT S
                LEFT JOIN DEPARTMENT D ON S.dept_code = D.dept_code
                WHERE S.student_id = {student_id}
                """

    query_scholarship = f"""
                SELECT student_id, scholarship_name, scholarship_value, scholarship_tenure, scholarship_start_date, scholarship_end_date
                FROM SCHOLARSHIP
                WHERE student_id = {student_id}
                ORDER BY scholarship_end_date DESC
                """

    query_employment = f"""
                SELECT student_id, company_name, employment_start_date, employment_end_date
                FROM EMPLOYMENT
                WHERE student_id = {student_id}
                ORDER BY employment_end_date DESC
                """

    query_supervisor = f"""
                SELECT CONCAT(S.fname, ' ', S.lname) AS Name, V.supv_type
                FROM SUPERVISION V
                LEFT JOIN STAFF S ON V.staff_id = S.staff_id
                WHERE V.student_id = {student_id}
                """

    connection = common.getCursor()

    connection.execute(query_profile)
    studentProfile = connection.fetchone()

    connection.execute(query_scholarship)
    studentScholarship = connection.fetchall()

    connection.execute(query_employment)
    studentEmployment = connection.fetchall()

    connection.execute(query_supervisor)
    studentSupervisor = connection.fetchall()

    return render_template("viewStudentDetail.html", studentProfile=studentProfile, studentScholarship=studentScholarship, studentEmployment=studentEmployment, studentSupervisor=studentSupervisor)

@admin_bp.route("/supervisorlist", methods=["GET", "POST"])
def viewSupervisorList():
    query = """
                SELECT S.staff_id, S.fname, S.lname, S.phone, S.email_lu, S.room, D.dept_name 
                FROM STAFF S
                LEFT JOIN DEPARTMENT D ON S.dept_code = D.dept_code
                WHERE S.role = 'Supervisor'
                """
    
    if request.method != "GET":
        staff_id = request.form.get('staffID')
        staff_name = request.form.get('staffName')
        department_code = request.form.get('departmentCode')
        conditions = []

        if staff_id is not None and staff_id.isdigit():
            conditions.append(f"S.staff_id = {staff_id}")

        if staff_name is not None and len(staff_name.strip()) > 0:
            conditions.append(f"(S.fname LIKE '%{staff_name}%' OR S.lname LIKE '%{staff_name}%')")
        
        if department_code is not None and len(department_code.strip()) > 0:
            conditions.append(f"S.dept_code LIKE '%{department_code}%'")

        if conditions:
            query += " AND (" + " OR ".join(conditions) + ")"

    connection = common.getCursor()
    connection.execute(query)
    supervisorList = connection.fetchall()
    return render_template("viewSupervisorList.html", supervisorList=supervisorList)

@admin_bp.route("/activatestudentaccount", methods=["GET", "POST"])
def activateStudentAccount():
    connection = common.getCursor()

    if request.method != "GET":
        studentID = request.args.get('id')
        action = request.args.get('action')
        connection.execute(f'SELECT email_lu FROM STUDENT WHERE student_id = {studentID}')
        studentEmail = connection.fetchone()[0]
        print(studentEmail)

        if action == 'activate':
            query = f"""
                    UPDATE USER 
                    SET admin_flag = '1' 
                    WHERE email_lu = (
                        SELECT email_lu 
                        FROM STUDENT 
                        WHERE student_id = {studentID}
                    ) 
                    AND role = 'Student'
                    """
            emailBody = "Your user account has been activated!"
        else:
            query = f"""
                    DELETE FROM USER 
                    WHERE email_lu = (
                        SELECT email_lu 
                        FROM STUDENT 
                        WHERE student_id = {studentID}
                    ) 
                    AND role = 'Student';
                    """
            emailBody = "Your user account request has been declined!"

        connection.execute(query)
        emailTitle = 'Notification from Lincoln Admin'
        sendMail(emailTitle, studentEmail, emailBody)

    query = """
                SELECT student_id, fname, lname, enrollment_date, dept_code, USER.email_lu
                FROM USER 
                INNER JOIN STUDENT ON USER.email_lu = STUDENT.email_lu
                WHERE role = 'Student' AND admin_flag = '0'
                """        

    connection.execute(query)
    inactiveStudents = connection.fetchall()
    print(inactiveStudents)
    return render_template("activateStudentAccount.html", inactiveStudents=inactiveStudents)

#### Na
@admin_bp.route("/reminder", methods=["GET", "POST"])
def reminder():
    connection = getCursor()
    # get email addresses!
    connection.execute("SELECT s.email_lu \
                    FROM student AS s \
                    JOIN report AS r ON s.student_id = r.student_id \
                    JOIN report_progress AS rp ON r.report_id = rp.report_id \
                    WHERE r.rept_term = %s AND r.rept_year = %s \
                    AND rp.full_report_completed = 0", ('JUNE', '2023',))
    emailaddress=connection.fetchall()
    emailTitle = '6MR report reminder!'
    emailBody=request.form.get('body')
    if request.method == 'POST':
        for email in emailaddress:
            email=email[0]
            sendMail(emailTitle, email, emailBody)
        msg= "Emails sent successfully" 
        return render_template("admin.html", msg=msg)
    else:
        return render_template("reminder.html")
    
# from datetime import date
# today = date.today()
# due_date = date(2023, 6, 30)

# date_difference = due_date - today
# if date_difference == 7:
#     connection = getCursor()
#     # Get email addresses
#     connection.execute("SELECT s.email_lu \
#                         FROM student AS s \
#                         JOIN report AS r ON s.student_id = r.student_id \
#                         JOIN report_progress AS rp ON r.report_id = rp.report_id \
#                         WHERE r.rept_term = %s AND r.rept_year = %s \
#                         AND rp.full_report_completed = 0", ('JUNE', '2023'))
#     email_addresses = [email[0] for email in connection.fetchall()]

#     # Email details
#     email_title = '6MR report reminder!'
#     email_body = request.form.get('body')

#     if email_addresses:
#         for email in email_addresses:
#             sendMail(email_title, email, email_body)
        
#         msg = "Emails sent successfully"
#         return render_template("admin.html", msg=msg)

# automatic email   admin can change the email content ????