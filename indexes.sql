-- =============================================
-- TCSI Extract Database - Index Definitions
-- Version: 2.0
-- Date: September 2025
-- Description: Performance optimization indexes for TCSI database
-- =============================================

-- =============================================
-- CLUSTERED INDEXES (Primary Keys)
-- Note: Primary keys automatically create clustered indexes
-- Listed here for documentation purposes
-- =============================================

-- These are created automatically with PRIMARY KEY constraints:
-- IX_PK_HEPStudents ON HEPStudents(Student_key)
-- IX_PK_CourseAdmissions ON CourseAdmissions(UID15_CourseAdmissionsResKey)
-- IX_PK_UnitEnrolments ON UnitEnrolments(UID16_UnitEnrolmentsResKey)
-- etc.

-- =============================================
-- FOREIGN KEY INDEXES
-- Indexes on foreign key columns for join performance
-- =============================================

-- StudentResidentialAddress FK Indexes
CREATE INDEX IX_StudentAddress_StudentKey 
ON StudentResidentialAddress(Student_key);

-- CourseAdmissions FK Indexes
CREATE INDEX IX_CourseAdmissions_StudentKey 
ON CourseAdmissions(Student_key);

CREATE INDEX IX_CourseAdmissions_CourseKey 
ON CourseAdmissions(UID5_CoursesResKey);

-- UnitEnrolments FK Indexes
CREATE INDEX IX_UnitEnrolments_StudentKey 
ON UnitEnrolments(Student_key);

CREATE INDEX IX_UnitEnrolments_AdmissionKey 
ON UnitEnrolments(UID15_CourseAdmissionsResKey);

-- SAHELP FK Indexes
CREATE INDEX IX_SAHELP_StudentKey 
ON SAHELP(Student_key);

-- Courses FK Indexes
CREATE INDEX IX_Courses_CourseOfStudyKey 
ON Courses(UID3_CoursesOfStudyResKey);

-- CoursesOnCampuses FK Indexes
CREATE INDEX IX_CoursesOnCampuses_CourseKey 
ON CoursesOnCampuses(UID5_CoursesResKey);

CREATE INDEX IX_CoursesOnCampuses_CampusKey 
ON CoursesOnCampuses(UID30_CampusesResKey);

-- CampusCourseFees FK Indexes
CREATE INDEX IX_CampusCourseFees_CourseOnCampusKey 
ON CampusCourseFees(UID4_CoursesOnCampusResKey);

-- AggregatedAwards FK Indexes
CREATE INDEX IX_AggregatedAwards_StudentKey 
ON AggregatedAwards(Student_key);

CREATE INDEX IX_AggregatedAwards_CourseKey 
ON AggregatedAwards(UID5_CoursesResKey);

-- ExitAwards FK Indexes
CREATE INDEX IX_ExitAwards_StudentKey 
ON ExitAwards(Student_key);

CREATE INDEX IX_ExitAwards_CourseKey 
ON ExitAwards(UID5_CoursesResKey);

-- =============================================
-- BUSINESS QUERY INDEXES
-- Indexes for common query patterns
-- =============================================

-- Student lookup by identification code
CREATE UNIQUE INDEX IX_Student_IdentificationCode 
ON HEPStudents(E313_StudentIdentificationCode);

-- Student lookup by CHESSN
CREATE UNIQUE INDEX IX_Student_CHESSN 
ON HEPStudents(E488_CHESSN) 
WHERE E488_CHESSN IS NOT NULL;

-- Student lookup by USI
CREATE UNIQUE INDEX IX_Student_USI 
ON HEPStudents(E584_USI) 
WHERE E584_USI IS NOT NULL;

-- Student name search
CREATE INDEX IX_Student_Name 
ON HEPStudents(E401_PersonSurname, E402_PersonGivenName);

-- Student demographic queries
CREATE INDEX IX_Student_Demographics 
ON HEPStudents(E314_GenderCode, E316_ATSICode, E358_CitizenshipCode);

-- Student status queries
CREATE INDEX IX_Student_Status 
ON HEPStudents(E490_StudentStatusCode);

-- Course lookup by code
CREATE UNIQUE INDEX IX_Course_Code 
ON Courses(E307_CourseCode);

-- Course name search
CREATE INDEX IX_Course_Name 
ON Courses(E308_CourseName);

-- Course type queries
CREATE INDEX IX_Course_Type 
ON Courses(E310_CourseOfStudyType);

-- Active courses (non-composite for better performance)
CREATE INDEX IX_Course_EffectiveDates 
ON Courses(E609_EffectiveFromDate, E610_EffectiveToDate);

-- Unit enrollment by census date
CREATE INDEX IX_UnitEnrolment_CensusDate 
ON UnitEnrolments(E489_UnitOfStudyCensusDate);

-- Unit enrollment by unit code and status
CREATE INDEX IX_UnitEnrolment_UnitStatus 
ON UnitEnrolments(E354_UnitOfStudyCode, E355_UnitOfStudyStatusCode);

-- Unit enrollment by mode of attendance
CREATE INDEX IX_UnitEnrolment_ModeOfAttendance 
ON UnitEnrolments(E329_ModeOfAttendanceCode);

-- Course admission by commencement date
CREATE INDEX IX_CourseAdmission_CommencementDate 
ON CourseAdmissions(E534_CourseOfStudyCommDate);

-- Current student addresses (partial index)
CREATE INDEX IX_StudentAddress_Current 
ON StudentResidentialAddress(Student_key, effective_from_date) 
WHERE effective_to_date IS NULL;

-- Address by postcode (for geographic analysis)
CREATE INDEX IX_StudentAddress_Postcode 
ON StudentResidentialAddress(E470_ResidentialAddressPostcode);

-- =============================================
-- REPORTING INDEXES
-- Optimized for common reporting queries
-- =============================================

-- Reporting year indexes for incremental loading
CREATE INDEX IX_CourseAdmissions_ReportingYear 
ON CourseAdmissions(reporting_year, E534_CourseOfStudyCommDate);

CREATE INDEX IX_UnitEnrolments_ReportingYear 
ON UnitEnrolments(reporting_year, E489_UnitOfStudyCensusDate);

CREATE INDEX IX_SAHELP_ReportingYear 
ON SAHELP(reporting_year, E415_ReportingDate);

CREATE INDEX IX_AggregatedAwards_ReportingYear 
ON AggregatedAwards(reporting_year, E552_AggregatedAwardCourseReportingDate);

CREATE INDEX IX_ExitAwards_ReportingYear 
ON ExitAwards(reporting_year, E593_AwardCompletionYear);

-- Extraction date for data lineage
CREATE INDEX IX_Student_ExtractionDate 
ON HEPStudents(extraction_date);

-- EFTSL calculations
CREATE INDEX IX_UnitEnrolment_EFTSL 
ON UnitEnrolments(E339_EFTSL, E489_UnitOfStudyCensusDate)
WHERE E355_UnitOfStudyStatusCode = 'Enrolled';

-- Financial queries
CREATE INDEX IX_SAHELP_Financial 
ON SAHELP(E558_LoanToSAHELP, E415_ReportingDate)
WHERE E392_HELPEligibilityCode = 'Y';

CREATE INDEX IX_UnitEnrolment_Financial 
ON UnitEnrolments(E381_AmountChargedUpfront, E384_AmountPaidUpfront)
WHERE E381_AmountChargedUpfront > 0;

-- Award completions
CREATE INDEX IX_ExitAwards_CompletionDate 
ON ExitAwards(E592_AwardCourseCompletionDate, E594_AwardCourseType);

-- Campus course offerings
CREATE INDEX IX_CoursesOnCampuses_Active 
ON CoursesOnCampuses(UID5_CoursesResKey, UID30_CampusesResKey)
WHERE E610_EffectiveToDate IS NULL;

-- Fee structures
CREATE INDEX IX_CampusCourseFees_Current 
ON CampusCourseFees(UID4_CoursesOnCampusResKey, E609_EffectiveFromDate)
WHERE E610_EffectiveToDate IS NULL;

-- =============================================
-- COMPOSITE INDEXES FOR COMPLEX QUERIES
-- =============================================

-- Student enrollment history
CREATE INDEX IX_Student_EnrollmentHistory 
ON UnitEnrolments(Student_key, E489_UnitOfStudyCensusDate, E355_UnitOfStudyStatusCode)
INCLUDE (E354_UnitOfStudyCode, E339_EFTSL);

-- Course admission with student details
CREATE INDEX IX_CourseAdmission_StudentCourse 
ON CourseAdmissions(Student_key, UID5_CoursesResKey, E534_CourseOfStudyCommDate);

-- Geographic distribution analysis
CREATE INDEX IX_Student_Geographic 
ON StudentResidentialAddress(E470_ResidentialAddressState, E470_ResidentialAddressPostcode)
WHERE effective_to_date IS NULL;

-- International students
CREATE INDEX IX_Student_International 
ON HEPStudents(E358_CitizenshipCode, E347_YearOfArrivalInAustralia)
WHERE E358_CitizenshipCode != 'AU';

-- HDR students
CREATE INDEX IX_CourseAdmission_HDR 
ON CourseAdmissions(E622_ResearchMastersCommencementDate, E623_DoctoralCommencementDate)
WHERE E622_ResearchMastersCommencementDate IS NOT NULL 
   OR E623_DoctoralCommencementDate IS NOT NULL;

-- =============================================
-- FULL-TEXT SEARCH INDEXES (if supported)
-- For name and course searches
-- =============================================

-- Note: Syntax varies by database system
-- MySQL Example:
-- CREATE FULLTEXT INDEX FT_Student_Names 
-- ON HEPStudents(E401_PersonSurname, E402_PersonGivenName, E403_PersonMiddleName);

-- CREATE FULLTEXT INDEX FT_Course_Names 
-- ON Courses(E308_CourseName);

-- PostgreSQL Example (using GIN):
-- CREATE INDEX FT_Student_Names 
-- ON HEPStudents USING gin(to_tsvector('english', 
--     E401_PersonSurname || ' ' || E402_PersonGivenName));

-- =============================================
-- COVERING INDEXES (INCLUDE columns)
-- For query optimization - syntax varies by database
-- =============================================

-- SQL Server Example:
-- CREATE INDEX IX_UnitEnrolment_Coverage 
-- ON UnitEnrolments(Student_key, E489_UnitOfStudyCensusDate)
-- INCLUDE (E354_UnitOfStudyCode, E355_UnitOfStudyStatusCode, E339_EFTSL);

-- PostgreSQL 11+ Example:
-- CREATE INDEX IX_UnitEnrolment_Coverage 
-- ON UnitEnrolments(Student_key, E489_UnitOfStudyCensusDate)
-- INCLUDE (E354_UnitOfStudyCode, E355_UnitOfStudyStatusCode, E339_EFTSL);

-- =============================================
-- SPECIALIZED INDEXES
-- =============================================

-- Bitmap indexes for low cardinality columns (Oracle)
-- CREATE BITMAP INDEX BM_Student_Gender ON HEPStudents(E314_GenderCode);
-- CREATE BITMAP INDEX BM_Student_ATSI ON HEPStudents(E316_ATSICode);
-- CREATE BITMAP INDEX BM_Student_Status ON HEPStudents(E490_StudentStatusCode);

-- Hash indexes for exact match queries (PostgreSQL)
-- CREATE INDEX IX_Student_ID_Hash ON HEPStudents USING hash(E313_StudentIdentificationCode);

-- =============================================
-- INDEX MAINTENANCE STATEMENTS
-- =============================================

-- Rebuild fragmented indexes (SQL Server)
-- ALTER INDEX ALL ON HEPStudents REBUILD WITH (FILLFACTOR = 80);
-- ALTER INDEX ALL ON UnitEnrolments REBUILD WITH (FILLFACTOR = 90);

-- Update statistics (SQL Server)
-- UPDATE STATISTICS HEPStudents WITH FULLSCAN;
-- UPDATE STATISTICS UnitEnrolments WITH FULLSCAN;

-- Analyze tables (PostgreSQL/MySQL)
-- ANALYZE HEPStudents;
-- ANALYZE UnitEnrolments;
-- ANALYZE CourseAdmissions;

-- =============================================
-- MONITORING QUERIES
-- =============================================

-- Check index usage (PostgreSQL)
-- SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
-- FROM pg_stat_user_indexes
-- ORDER BY idx_scan;

-- Check index fragmentation (SQL Server)
-- SELECT 
--     OBJECT_NAME(ips.object_id) AS TableName,
--     si.name AS IndexName,
--     ips.avg_fragmentation_in_percent
-- FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
-- INNER JOIN sys.indexes si ON ips.object_id = si.object_id AND ips.index_id = si.index_id
-- WHERE ips.avg_fragmentation_in_percent > 10;

-- =============================================
-- NOTES ON INDEX STRATEGY
-- =============================================

/*
1. Primary Key Indexes: Automatically created, provide fast lookups
2. Foreign Key Indexes: Essential for join performance
3. Business Query Indexes: Based on common search patterns
4. Reporting Indexes: Optimized for analytical queries
5. Covering Indexes: Reduce key lookups for frequently accessed columns

Index Naming Convention:
- IX_: Standard index
- UQ_: Unique index
- FT_: Full-text index
- BM_: Bitmap index
- PK_: Primary key (clustered)

Maintenance Schedule:
- Weekly: Update statistics
- Monthly: Check fragmentation
- Quarterly: Rebuild fragmented indexes (>30% fragmentation)
- Annually: Review and optimize index strategy

Performance Considerations:
- Monitor index usage regularly
- Remove unused indexes to reduce maintenance overhead
- Consider partitioning for very large tables
- Use filtered indexes for queries with WHERE clauses
- Balance between read and write performance
*/

-- =============================================
-- END OF INDEX DEFINITIONS
-- =============================================