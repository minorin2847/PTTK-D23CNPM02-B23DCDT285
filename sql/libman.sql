-- LibMan database, following the "So do CSDL he thong" diagram.
CREATE DATABASE IF NOT EXISTS libman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE libman;

DROP TABLE IF EXISTS tblLoanDocumentItem5;
DROP TABLE IF EXISTS tblLoanSlip5;
DROP TABLE IF EXISTS tblReaderCard5;
DROP TABLE IF EXISTS tblImportDocumentItem5;
DROP TABLE IF EXISTS tblImportReceipt5;
DROP TABLE IF EXISTS tblSupplier5;
DROP TABLE IF EXISTS tblDocumentItem5;
DROP TABLE IF EXISTS tblDocument5;
DROP TABLE IF EXISTS tblReader5;
DROP TABLE IF EXISTS tblEmployee5;
DROP TABLE IF EXISTS tblUser5;

CREATE TABLE tblUser5 (
    id       INT(10)      NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name     VARCHAR(255) NOT NULL,
    birthday DATE,
    address  VARCHAR(255),
    email    VARCHAR(255),
    phone    VARCHAR(255),
    note     VARCHAR(255) NULL,
    PRIMARY KEY (id)
);

CREATE TABLE tblReader5 (
    studentid  VARCHAR(255) NOT NULL UNIQUE,
    tblUser5id INT(10)      NOT NULL,
    PRIMARY KEY (tblUser5id),
    FOREIGN KEY (tblUser5id) REFERENCES tblUser5 (id)
);

CREATE TABLE tblEmployee5 (
    role       VARCHAR(255) NOT NULL,
    tblUser5id INT(10)      NOT NULL,
    PRIMARY KEY (tblUser5id),
    FOREIGN KEY (tblUser5id) REFERENCES tblUser5 (id)
);

CREATE TABLE tblReaderCard5 (
    id         INT(10)      NOT NULL,
    image      BLOB,
    issueDate  DATE         NOT NULL,
    status     VARCHAR(255) NOT NULL,
    tblUser5id INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblUser5id) REFERENCES tblReader5 (tblUser5id)
);

CREATE TABLE tblDocument5 (
    code          VARCHAR(255) NOT NULL,
    type          VARCHAR(255) NOT NULL,
    name          VARCHAR(255) NOT NULL,
    author        VARCHAR(255) NOT NULL,
    publisher     VARCHAR(255) NOT NULL,
    publishedYear INT(10)      NULL,
    genre         VARCHAR(255) NOT NULL,
    description   VARCHAR(255) NULL,
    image         BLOB         NULL,
    PRIMARY KEY (code)
);

CREATE TABLE tblDocumentItem5 (
    id               INT(10)      NOT NULL,
    status           VARCHAR(255) NOT NULL,
    tblDocument5code VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblDocument5code) REFERENCES tblDocument5 (code)
);

CREATE TABLE tblLoanSlip5 (
    id               INT(10) NOT NULL AUTO_INCREMENT,
    loanDate         DATE    NOT NULL,
    tblReaderCard5id INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblReaderCard5id) REFERENCES tblReaderCard5 (id)
);

CREATE TABLE tblLoanDocumentItem5 (
    dueDate            DATE         NOT NULL,
    returnDate         DATE         NULL,
    status             VARCHAR(255) NOT NULL,
    tblLoanSlip5id     INT(10)      NOT NULL,
    tblDocumentItem5id INT(10)      NOT NULL,
    PRIMARY KEY (tblLoanSlip5id, tblDocumentItem5id),
    FOREIGN KEY (tblLoanSlip5id) REFERENCES tblLoanSlip5 (id),
    FOREIGN KEY (tblDocumentItem5id) REFERENCES tblDocumentItem5 (id)
);

-- Supplier / import tables (in the system diagram, not used by the two modules)
CREATE TABLE tblSupplier5 (
    id      INT(10)      NOT NULL AUTO_INCREMENT,
    name    VARCHAR(255) NOT NULL,
    email   VARCHAR(255),
    address VARCHAR(255),
    phone   VARCHAR(255),
    note    VARCHAR(255) NULL,
    PRIMARY KEY (id)
);

CREATE TABLE tblImportReceipt5 (
    id             INT(10) NOT NULL AUTO_INCREMENT,
    date           DATE    NOT NULL,
    total          DOUBLE  NOT NULL,
    tblSupplier5id INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblSupplier5id) REFERENCES tblSupplier5 (id)
);

CREATE TABLE tblImportDocumentItem5 (
    quantity           INT(10)      NOT NULL,
    price              DOUBLE       NOT NULL,
    tblDocument5id   VARCHAR(255) NOT NULL,
    tblImportReceipt5id INT(10)     NOT NULL,
    PRIMARY KEY (tblImportReceipt5id, tblDocument5id),
    FOREIGN KEY (tblDocument5id) REFERENCES tblDocument5 (code),
    FOREIGN KEY (tblImportReceipt5id) REFERENCES tblImportReceipt5 (id)
);

-- ---------------------------------------------------------------- sample data
INSERT INTO tblUser5 (id, username, password, name, birthday, address, email, phone) VALUES
 (1, 'reader1',    '123', 'Trần Văn A', '2005-01-15', 'Hà Nội', 'a@stu.edu.vn', '0900000001'),
 (2, 'librarian1', '123', 'Trần Văn B', '1990-06-20', 'Hà Nội', 'b@lib.edu.vn', '0900000002'),
 (3, 'reader2',    '123', 'Lê Thị C',   '2004-03-10', 'Hà Nội', 'c@stu.edu.vn', '0900000003');

INSERT INTO tblReader5 (studentid, tblUser5id) VALUES
 ('B23DCCN001', 1),
 ('B23DCCN002', 3);

INSERT INTO tblEmployee5 (role, tblUser5id) VALUES ('librarian', 2);

INSERT INTO tblReaderCard5 (id, issueDate, status, tblUser5id) VALUES
 (123456789, '2025-09-01', 'active', 1),
 (987654321, '2025-09-01', 'locked', 3);

INSERT INTO tblDocument5 (code, type, name, author, publisher, publishedYear, genre, description) VALUES
 ('ISBN-123-456-123456-0', 'Sách',    'Tài liệu 1',        'Nguyễn Văn A', 'Tri thức', 2007, 'Khoa học công nghệ', 'Tài liệu nói về việc Internet phát triển toàn thế giới'),
 ('ISBN-345-678-456789-3', 'Bài báo', 'Tài liệu 2',        'Nguyễn Văn A', 'Tri thức', 2014, 'Nghiên cứu khoa học', 'Bài báo nghiên cứu về hệ thống phân tán'),
 ('ISBN-111-222-333444-5', 'Giáo trình', 'Lập trình Java', 'Trần Thị D',   'Giáo dục', 2020, 'Công nghệ thông tin', 'Giáo trình lập trình Java cơ bản'),
 ('ISBN-555-666-777888-9', 'Tạp chí', 'Tạp chí Khoa học',  'Nhiều tác giả', 'KH&CN',   2023, 'Khoa học', 'Số đặc biệt về trí tuệ nhân tạo');

INSERT INTO tblDocumentItem5 (id, status, tblDocument5code) VALUES
 (321654987, 'available', 'ISBN-123-456-123456-0'),
 (321654988, 'available', 'ISBN-123-456-123456-0'),
 (789456123, 'available', 'ISBN-345-678-456789-3'),
 (111222333, 'available', 'ISBN-111-222-333444-5'),
 (555666777, 'borrowed',  'ISBN-555-666-777888-9');
