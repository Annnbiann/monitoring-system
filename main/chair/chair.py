from flask import (redirect, render_template, request, session, url_for)
from main.common import getCursor
from main.chair import chair_bp

@chair_bp.route("/")
def index():
    username = session.get('username')
    # return ("Chair")
    return render_template("chair.html", username=username)

@chair_bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

### 10# Chair view student --Frank

@chair_bp.route("/studentlist", methods=["GET", "POST"])
def studentlist():
    query = """
                SELECT S.student_id, CONCAT(S.fname, ' ', S.lname) Name, S.phone, S.email_lu, S.part_full_time, D.dept_name 
                FROM STUDENT S
                LEFT JOIN DEPARTMENT D ON S.dept_code = D.dept_code
                """
    
    if request.method != "GET":
        student_id = request.form.get('studentID')
        student_name = request.form.get('Name')
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

    connection = getCursor()
    connection.execute(query)
    studentList = connection.fetchall()
    connection.fetchall()
    return render_template("studentlist.html", studentList=studentList)

### 10# Chair view student --Frank

@chair_bp.route('/studentprofile')
def student_profile():
    connection = getCursor()
    student_name = request.args.get('Name').replace("+", " ")  # replace '+' with ' '
    # Store student_name in a variable and use it in the query
    query_1 = "SELECT *, CONCAT(S.fname, ' ', S.lname) Name FROM student S \
            LEFT JOIN report ON S.student_id = report.student_id \
            LEFT JOIN report_progress ON report.report_id = report_progress.report_id \
            LEFT JOIN section_e_convenor ON report.report_id = section_e_convenor.report_id \
            LEFT JOIN section_f on  report.report_id = section_f.report_id \
            WHERE CONCAT(S.fname, ' ', S.lname) = %s \
            ORDER BY Report.report_id ASC"
    connection.execute(query_1, (student_name,))
    report_data = connection.fetchall()
    student_profile = report_data[0]
    report_data = report_data
    query_2 = "SELECT supervision.supv_type, supervision.staff_id, CONCAT(student.fname, ' ', student.lname) Name, CONCAT(staff.fname, ' ', staff.lname) staff_name \
               FROM supervision \
               left join student on supervision.student_id = student.student_id \
               right join staff on supervision.staff_id = staff.staff_id \
               where CONCAT(student.fname, ' ', student.lname) = %s \
               Order by staff.staff_id ASC"
    connection.execute(query_2, (student_name,))
    Supervisor_list = connection.fetchall()
    query_3 = "SELECT scholarship.scholarship_name, scholarship.scholarship_value, scholarship.scholarship_tenure, scholarship.scholarship_start_date, scholarship.scholarship_end_date, CONCAT(student.fname, ' ', student.lname) Name \
               FROM scholarship \
               left join student on scholarship.student_id = student.student_id \
               where CONCAT(student.fname, ' ', student.lname) = %s \
               Order by scholarship.scholarship_start_date DESC"
    connection.execute(query_3, (student_name,))
    Scholarship_list = connection.fetchall()
    query_4 = "SELECT E.company_name, E.employment_start_date, E.employment_end_date, CONCAT(student.fname, ' ', student.lname) Name \
               FROM employment E \
               left join student on E.student_id = student.student_id \
               where CONCAT(student.fname, ' ', student.lname) = %s \
               Order by E.employment_start_date DESC"
    connection.execute(query_4, (student_name,))
    Employment_list = connection.fetchall()
    return render_template('studentprofile.html', student_profile=student_profile, report_data=report_data, Supervisor_list=Supervisor_list, Scholarship_list=Scholarship_list, Employment_list=Employment_list)

### #11 Chair view supervisors

@chair_bp.route("/supervisorlist", methods=["GET", "POST"])
def SupervisorList():
    query = """
                SELECT S.staff_id, CONCAT(S.fname, ' ', S.lname) Name, S.phone, S.email_lu, S.room, D.dept_name 
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

    connection = getCursor()
    connection.execute(query)
    supervisorList = connection.fetchall()
    return render_template("supervisorList.html", supervisorList=supervisorList)