from main import common
from main.common import getCursor
from flask import (redirect, render_template, request, session, url_for)
from main.convenor import convenor_bp

@convenor_bp.route("/")
def index():
    username = session.get('username')
    return render_template("convenor.html", username=username)

@convenor_bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

@convenor_bp.route("/studentlist", methods=["GET", "POST"])
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
    return render_template("convenor_viewStudentList.html", studentList=studentList)

@convenor_bp.route("/studentdetail/<int:student_id>", methods=["GET", "POST"])
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

    return render_template("convenor_viewStudentDetail.html", studentProfile=studentProfile, studentScholarship=studentScholarship, studentEmployment=studentEmployment, studentSupervisor=studentSupervisor)

@convenor_bp.route("/supervisorlist", methods=["GET", "POST"])
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
    return render_template("convenor_viewSupervisorList.html", supervisorList=supervisorList) 