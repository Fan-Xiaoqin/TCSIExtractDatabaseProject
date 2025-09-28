# Meeting Notes: 4th September

### 1. ERD (Entity Relationship Diagram) Review

The team reviewed two versions of the ERD with a focus on:
* **Primary tables to keep:** Students, Course Admissions, Unit Enrollments, and their related sub-packets
* **Tables to potentially remove:** Campus and Course on Campus (later decided to keep)
* **Critical relationships:** Student → Course Admission → Unit Enrollment

### 2. Major Design Decisions

**Primary Key Structure:**
* Unit enrollment primary key should include: Student ID, Course Code, Unit ID, Census Date, Unit Status
* Not based on EFTSL amounts

**Student Loans Restructuring:**
* Original design had a superclass "Student Loans" with SAHELP and OSHELP as subclasses
* **Final decision:** Separate SAHELP and OSHELP into two independent tables
* **Reasoning:** These are completely different loan types with no commonality

**Timestamps and Versioning:**
* Add Load Batch ID to track data updates
* Include timestamps for: Unit Enrollment, Course Admission, Student tables
* AsAtMonth field for monthly snapshots

### 3. Data Relationships Clarified

**HDR (Higher Degree Research) Structure:**
* HDR End User Engagement connects to Course Admission, not directly to Student
* Represents PhD students' external research engagements (e.g., with CSIRO)

**Course Relationships:**
* Keep Courses table (not Course of Study)
* Special Interest Courses links through Courses
* RTP Scholarships connect to Course Admission

### 4. Project Deliverables Confirmed

**SQL Scripts:**
* Database schema creation
* Table relationships
* Views creation

**R Scripts:**
* Read and validate CSV/Excel data
* Data cleaning and transformation
* Database upload procedures
* RStudio to database connection

**Documentation:**
* ERD diagrams
* Schema upload process
* RStudio connection guides
