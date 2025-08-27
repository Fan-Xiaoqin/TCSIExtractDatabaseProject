# TCSIExtractDatabaseProject

This project is planning to develop a **new database solution** to **store** and **manage** student extracted data from TCSI (Tertiary Collection of Student Information), with the following feature:

1. Extracted data from CSV, where filed name is fixed;
   
2. Supports relationship across multiple tables;
   
3. Preseves historical information (without overwritten existing data);
   
4. Integrated with RStudio for analysis;
   
5. Metadata: timestamps;

6. Develop a single, analysis-ready view (with all important fields);

7. Supports query like: function(db_table_name, query_condition_1 = NULL, query_condition_2 = NULL, ...); 
