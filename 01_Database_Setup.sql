/* GOMATO PROJECT - 01 DATABASE SETUP
   Purpose: Create the project database only if it does not already exist.
*/
USE master;
GO
IF DB_ID(N'GomatoDB') IS NULL
    CREATE DATABASE GomatoDB;
GO
USE GomatoDB;
GO
