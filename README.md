# Heather Sweeney Designs (HSD) – MySQL Database

Relational database design for **Heather Sweeney Designs**, a business that runs design seminars and sells products. The database tracks customers, seminar registrations, products, invoices and the contacts made with customers.

## Contents

| File | Description |
|------|-------------|
| `CreateDataBaseSeminar.sql` | MySQL script that creates the `HSD` database and all 7 tables |
| `HSD_Database_Design_Document.docx` | Database Design Document: ERD, data dictionary, relations, SQL appendix, test case |

## Tables

`Customer`, `Seminar`, `Seminar_Customer`, `Prodact`, `Invoice`, `Line_item`, `Contact`

## Relationships

- Customer 1 : N Invoice
- Invoice 1 : N Line_item
- Prodact 1 : N Line_item
- Customer M : N Seminar, resolved by `Seminar_Customer`
- Customer 1 : N Contact, Seminar 1 : N Contact

## Design highlights

- Composite primary keys: `(InvoiceNumber, LineNumber)`, `(SeminarID, CustomerID)`, `(CustomerID, ContactNumber)`
- Foreign keys on every relationship to enforce referential integrity
- `CHECK` constraints for prices, quantities, phone length (11) and zip length (6)
- `UNIQUE` email and phone so a customer cannot register twice
- Money columns use `DECIMAL(10,2)`
- Passwords are stored hashed (`VARCHAR(256)`); length rules are validated in the application before hashing

## How to run

Requires **MySQL 8.0.16+** (earlier versions parse but ignore `CHECK` constraints).

```bash
mysql -u root -p < CreateDataBaseSeminar.sql
```

Tables are created in dependency order (`Invoice` before `Line_item`), otherwise MySQL rejects the foreign key.

## Author

Mohamed Abd El-Ghaney
