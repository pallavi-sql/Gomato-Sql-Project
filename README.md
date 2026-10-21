# Gomato SQL Project

## Project overview
Gomato is a sample women-focused quick-commerce business used to practise SQL Server database design, data validation, business reporting, reusable SQL objects, and performance basics.

## Core tables
Customer, Address, Category, Store, Product, DeliveryPartners, Orders, OrderDetails.

## Script order
1. `01_Database_Setup.sql`
2. `02_Table_Creation.sql`
3. `03_Sample_Data.sql`
4. `04_Data_Validation.sql`
5. `05_Business_Analysis.sql`
6. `06_Joins.sql`
7. `07_Subqueries.sql`
8. `08_CTEs.sql`
9. `09_Window_Functions.sql`
10. `10_Advanced_SQL.sql`
11. `11_SQL_Objects.sql`
12. `12_Performance_Optimization.sql`

## Important notes
- These are a consolidated learning version of the project scripts, not a verified copy of every earlier SSMS tab.
- Review column names against your existing database before running any script.
- If the database and tables already exist, do not drop them. The setup scripts use existence checks for core objects.
- Sample data insertion is designed to run only when each table is empty; if your tables already contain different data, compare before running it.
- The sample order totals and detail totals may not all reconcile; the validation scripts intentionally help surface those differences.
- The trigger audit table is an extra supporting table for auditing order status changes, not one of the eight core business tables.
- Performance results depend on SQL Server version, data volume, statistics, and execution plans. Do not claim a measured improvement without benchmarking.
