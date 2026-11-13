-- ============================================================
-- Heather Sweeney Designs (HSD) database
-- MySQL 8.0.16+ (CHECK constraints are enforced from 8.0.16)
-- Tables are created in dependency order: a table must exist
-- before any other table references it with a FOREIGN KEY.
-- ============================================================

CREATE DATABASE IF NOT EXISTS HSD;
USE HSD;

-- ------------------------------------------------------------
-- Seminar
-- ------------------------------------------------------------
CREATE TABLE Seminar (
    SeminarID     INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SeminarDate   DATE        NOT NULL,
    SeminarTime   TIME,
    Location      VARCHAR(50) NOT NULL,
    SeminarTitle  VARCHAR(50)
);

-- ------------------------------------------------------------
-- Customer
-- CusPassword is VARCHAR(256) so it can hold a hashed password.
-- Password rules (8-15 characters) must be validated in the
-- application BEFORE hashing, not as a CHECK on the stored value.
-- ------------------------------------------------------------
CREATE TABLE Customer (
    CustomerID     INT          NOT NULL AUTO_INCREMENT,
    LName          VARCHAR(50)  NOT NULL,
    FName          VARCHAR(50)  NOT NULL,
    Email          VARCHAR(100) NOT NULL UNIQUE,
    CusPassword    VARCHAR(256) NOT NULL,
    Phone          VARCHAR(15)  NOT NULL UNIQUE,
    StreetAddress  VARCHAR(100),
    City           VARCHAR(25)  NOT NULL,
    Governorate    VARCHAR(25)  NOT NULL,
    Zip            VARCHAR(10)  NOT NULL,

    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID),
    CONSTRAINT CHK_Zip     CHECK (CHAR_LENGTH(Zip) = 6),
    CONSTRAINT CHK_Phone   CHECK (CHAR_LENGTH(Phone) = 11)
);

-- ------------------------------------------------------------
-- Seminar_Customer (junction table: Customer <-> Seminar, M:N)
-- ------------------------------------------------------------
CREATE TABLE Seminar_Customer (
    SeminarID   INT NOT NULL,
    CustomerID  INT NOT NULL,

    CONSTRAINT pr_Seminar_Customer PRIMARY KEY (SeminarID, CustomerID),
    CONSTRAINT fk_sc_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT fk_sc_Seminar FOREIGN KEY (SeminarID)
        REFERENCES Seminar(SeminarID)
);

-- ------------------------------------------------------------
-- Prodact (product catalogue)
-- Quantity may be 0 so an out-of-stock product can still exist.
-- ------------------------------------------------------------
CREATE TABLE Prodact (
    ProductID           INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductType         VARCHAR(25)   NOT NULL,
    ProductDescription  VARCHAR(100),
    UnitPrice           DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0.0),
    Quantity            INT           NOT NULL CHECK (Quantity >= 0)
);

-- ------------------------------------------------------------
-- Invoice (must be created BEFORE Line_item)
-- Money columns are DECIMAL(10,2); Tax may be 0 for tax-free invoices.
-- ------------------------------------------------------------
CREATE TABLE Invoice (
    InvoiceNumber  INT           NOT NULL PRIMARY KEY,
    InvoiceDate    DATE          NOT NULL,
    CustomerID     INT           NOT NULL,
    InvoieType     VARCHAR(50),
    SubTotal       DECIMAL(10,2) NOT NULL CHECK (SubTotal > 0),
    Shipping       VARCHAR(50)   NOT NULL,
    Tax            DECIMAL(10,2) NOT NULL CHECK (Tax >= 0),
    Total          DECIMAL(10,2) NOT NULL CHECK (Total > 0),

    CONSTRAINT fk_invoice_customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
);

-- ------------------------------------------------------------
-- Line_item (references Invoice and Prodact)
-- ------------------------------------------------------------
CREATE TABLE Line_item (
    InvoiceNumber  INT           NOT NULL,
    LineNumber     INT           NOT NULL,
    ProductID      INT           NOT NULL,
    Quantity       INT           NOT NULL CHECK (Quantity > 0),
    UnitPrice      DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    Total          DECIMAL(10,2) NOT NULL CHECK (Total > 0),

    CONSTRAINT pr_line_invoice PRIMARY KEY (InvoiceNumber, LineNumber),
    CONSTRAINT fk_product_line FOREIGN KEY (ProductID)
        REFERENCES Prodact(ProductID),
    CONSTRAINT fk_invoice_line FOREIGN KEY (InvoiceNumber)
        REFERENCES Invoice(InvoiceNumber)
);

-- ------------------------------------------------------------
-- Contact (contacts made with a customer about a seminar)
-- ------------------------------------------------------------
CREATE TABLE Contact (
    CustomerID     INT NOT NULL,
    ContactNumber  INT NOT NULL,
    ContactType    VARCHAR(50),
    SeminarID      INT NOT NULL,

    CONSTRAINT pk_contact_customer PRIMARY KEY (CustomerID, ContactNumber),
    CONSTRAINT fk_customer_contact FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT fk_seminar_contact FOREIGN KEY (SeminarID)
        REFERENCES Seminar(SeminarID)
);
