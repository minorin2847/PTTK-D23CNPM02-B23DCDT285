# LibMan – 2 modules (JSP + JDBC + MySQL + DAO)

Implements the two modules of the design document *PTTK - 01B23DCDT285.pdf*, following its package
diagram **view → dao → model**:

| Module | Pages (view) | DAO | Model |
|---|---|---|---|
| 1. Reader finds document information | `ReaderMainFrm5` → `FindDocumentFrm5` → `DocumentInfoFrm5` | `DocumentDAO5.searchDocuments(searchType, searchQuery)` | `Document5`, `Reader5`, `User5` |
| 2. Librarian lends documents | `LibrarianMainFrm5` → `GetReaderCardInfoFrm5` → `LendDocumentFrm5` → `doLoanSlip.jsp` → `LoanSlipPreviewFrm5` | `ReaderCardDAO5.getReaderCard(id)`, `DocumentItemDAO5.getDocument(id)`, `LoanSlipDAO5.saveLoanSlip(slip)` | `ReaderCard5`, `DocumentItem5`, `LoanSlip5`, `LoanDocumentItem5`, `Librarian5`, `Employee5` |

## Structure

```
LibMan/
├── pom.xml
├── sql/libman.sql                      database (from "Sơ đồ CSDL") + sample data
└── src/main/
    ├── java/
    │   ├── model/                      entity classes
    │   └── dao/                        DAO5 (holds `con`) + one DAO per diagram, UserDAO5 for login
    └── webapp/
        ├── WEB-INF/web.xml
        └── view/
            ├── user/                   LoginFrm5.jsp, doLogout.jsp
            ├── reader/                 module 1 pages
            ├── librarian/              module 2 pages
            ├── common/style.css
            └── Error.jsp
```

As in the design (no controller layer), each `*Frm5.jsp` page calls its DAO directly; pages that
handle their own form submit post back to themselves (the self-association on `FindDocumentFrm5`,
`GetReaderCardInfoFrm5` and `LendDocumentFrm5` in the class diagrams). Saving the slip goes through
`doLoanSlip.jsp`, as in the module 2 detail class diagram.

Page flow follows the state diagrams: on `LoanSlipPreviewFrm5`, *In phiếu* prints and returns to
`LibrarianMainFrm5`; *Quay lại* returns to `LendDocumentFrm5` with a new empty slip for the same reader.

## Run

1. Create the database (MySQL 8):
   ```
   mysql -u root -p < sql/libman.sql
   ```
2. DB connection defaults to `jdbc:mysql://localhost:3306/libman`, user `root`, password `root`.
   Override with environment variables `LIBMAN_DB_URL`, `LIBMAN_DB_USER`, `LIBMAN_DB_PASSWORD`.
3. Build and deploy to **Tomcat 9** (uses the `javax.*` Servlet API; Tomcat 10+ needs `jakarta.*`):
   ```
   mvn package            # -> target/libman.war, copy into tomcat/webapps/
   ```
   Or in Eclipse/IntelliJ: import as a Maven project and run on a Tomcat 9 server.
4. Open http://localhost:8080/libman/

## Sample data

| Login | Password | Role |
|---|---|---|
| `reader1` | `123` | Reader Trần Văn A (card `123456789`, active) |
| `reader2` | `123` | Reader Lê Thị C (card `987654321`, **locked**) |
| `librarian1` | `123` | Librarian Trần Văn B |

Document copies (barcodes): `321654987`, `321654988`, `789456123`, `111222333` (available),
`555666777` (already borrowed).

## Notes

- `saveLoanSlip` runs in one transaction: it inserts the slip and its lines and marks each copy
  `borrowed` only if it is still `available`. If any copy was taken in the meantime, the whole slip
  is rolled back.
- Deployment (as in the deployment diagram): `libman.war` on Tomcat, MySQL database `libman` over JDBC (port 3306).
- Due date = loan date + 14 days (`LOAN_DAYS` in `LendDocumentFrm5.jsp`).
- `LoanSlip5.documents` is an `ArrayList<LoanDocumentItem5>` (the diagram's `LoanDocumentItem5[]`)
  so lines can be added and removed while the slip is being built.
- Passwords are stored in plain text, as in the lab tutorial. Hash them for real use.
