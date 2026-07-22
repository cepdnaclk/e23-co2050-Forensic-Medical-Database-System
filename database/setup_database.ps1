# ================================================================
# FMDS PostgreSQL Automatic Setup
# Project : Forensic Medical Department Database System
# Database: forensic_db
# DBMS    : PostgreSQL 18
# ================================================================

$ErrorActionPreference = "Stop"

# ------------------------------------------------
# PostgreSQL installation
# ------------------------------------------------

$psql = "C:\Program Files\PostgreSQL\18\bin\psql.exe"
$createdb = "C:\Program Files\PostgreSQL\18\bin\createdb.exe"

# ------------------------------------------------
# Database configuration
# ------------------------------------------------

$databaseName = "forensic_db"
$databaseUser = "postgres"

# Folder containing this script
$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "===================================================="
Write-Host " FMDS PostgreSQL Database Setup"
Write-Host "===================================================="
Write-Host ""

Write-Warning "This script will DELETE and recreate the entire 'fmds' schema."

$answer = Read-Host "Type YES to continue"

if ($answer -ne "YES") {
    Write-Host ""
    Write-Host "Setup cancelled."
    exit
}

# ------------------------------------------------
# Verify PostgreSQL installation
# ------------------------------------------------

if (!(Test-Path $psql)) {
    Write-Host ""
    Write-Error "psql.exe was not found."

    Write-Host ""
    Write-Host "Expected location:"
    Write-Host $psql
    exit
}

if (!(Test-Path $createdb)) {
    Write-Host ""
    Write-Error "createdb.exe was not found."

    Write-Host ""
    Write-Host "Expected location:"
    Write-Host $createdb
    exit
}

# ------------------------------------------------
# Check whether database exists
# ------------------------------------------------

Write-Host ""
Write-Host "Checking database..."

$databaseExists = & $psql `
    -U $databaseUser `
    -d postgres `
    -tAc "SELECT 1 FROM pg_database WHERE datname='$databaseName';"

if ($databaseExists -ne "1") {

    Write-Host ""
    Write-Host "Database not found."
    Write-Host "Creating database..."

    & $createdb `
        -U $databaseUser `
        $databaseName

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Database creation failed."
    }

    Write-Host "Database created successfully."
}
else {

    Write-Host ""
    Write-Host "Database already exists."
}

# ------------------------------------------------
# SQL files to execute
# ------------------------------------------------

$sqlFiles = @(

    "01_fmds_create_25_tables.sql",

    "02_fmds_constraints_indexes.sql",

    "03_fmds_unique_sample_data.sql",

    "04_fmds_verification_queries.sql",

    "05_fmds_views.sql",

    "06_fmds_functions_procedures.sql",

    "07_fmds_triggers_audit.sql",

    "08_fmds_roles_permissions.sql"

)

# ------------------------------------------------
# Execute SQL files
# ------------------------------------------------

foreach ($file in $sqlFiles) {

    $fullPath = Join-Path $scriptFolder $file

    if (!(Test-Path $fullPath)) {

        Write-Host ""
        Write-Error "Missing SQL file: $file"
    }

    Write-Host ""
    Write-Host "--------------------------------------------"
    Write-Host "Running $file"
    Write-Host "--------------------------------------------"

    & $psql `
        -U $databaseUser `
        -d $databaseName `
        -v ON_ERROR_STOP=1 `
        -f $fullPath

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Error "Execution failed."

        Write-Host ""
        Write-Host "Stopped while executing:"
        Write-Host $file

        exit
    }

    Write-Host ""
    Write-Host "$file completed successfully."
}

# ------------------------------------------------
# Final verification
# ------------------------------------------------

Write-Host ""
Write-Host "============================================"
Write-Host "Running final verification..."
Write-Host "============================================"

& $psql `
    -U $databaseUser `
    -d $databaseName `
    -v ON_ERROR_STOP=1 `
    -c "SET search_path TO fmds, public;
        SELECT COUNT(*) AS total_tables
        FROM information_schema.tables
        WHERE table_schema='fmds'
        AND table_type='BASE TABLE';"

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Error "Verification failed."

    exit
}

Write-Host ""
Write-Host "===================================================="
Write-Host " FMDS DATABASE SETUP COMPLETED SUCCESSFULLY"
Write-Host "===================================================="
Write-Host ""
Write-Host "Database : forensic_db"
Write-Host "Schema   : fmds"
Write-Host "Tables   : 25"
Write-Host ""
Write-Host "All SQL files executed successfully."
Write-Host ""
Write-Host "Project is ready to use."
Write-Host ""