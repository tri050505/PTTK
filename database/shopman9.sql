-- ShopMan9 - CSDL theo Hinh 4.2 (thiet ke CSDL) + du lieu mau cho Modul 1 va Modul 2
-- Tai khoan mau: manager / Abc12345  (NV quan li)   |   khach01 / Abc12345 (khach hang)
-- Chay lai file nay se XOA va tao lai CSDL shopman9.

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS shopman9;
CREATE DATABASE shopman9 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopman9;

-- ---------- Thanh vien: Member9 <- Customer9, Staff9 ----------
CREATE TABLE tblMember9 (
    id        INT(10) AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(255) NOT NULL UNIQUE,
    password  VARCHAR(255) NOT NULL,
    fullName  VARCHAR(255) NOT NULL,
    birthDate DATE,
    address   VARCHAR(255),
    email     VARCHAR(255) NOT NULL UNIQUE,
    phone     VARCHAR(20),
    role      VARCHAR(50)  NOT NULL DEFAULT 'customer'
);

CREATE TABLE tblStaff9 (
    tblMember9id INT(10) PRIMARY KEY,
    staffCode    VARCHAR(50) NOT NULL UNIQUE,
    position     VARCHAR(50) NOT NULL,
    CONSTRAINT fk_staff_member FOREIGN KEY (tblMember9id) REFERENCES tblMember9(id)
);

CREATE TABLE tblCustomer9 (
    tblMember9id INT(10) PRIMARY KEY,
    customerCode VARCHAR(50) NOT NULL UNIQUE,
    registerDate DATE NOT NULL,
    CONSTRAINT fk_customer_member FOREIGN KEY (tblMember9id) REFERENCES tblMember9(id)
);

-- ---------- Hang hoa, nha cung cap ----------
CREATE TABLE tblSupplier9 (
    id      INT(10) AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone   VARCHAR(20),
    email   VARCHAR(255)
);

CREATE TABLE tblCategory9 (
    id          INT(10) AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE tblProduct9 (
    id             INT(10) AUTO_INCREMENT PRIMARY KEY,
    productCode    VARCHAR(50)  NOT NULL UNIQUE,
    name           VARCHAR(255) NOT NULL,
    sellingPrice   FLOAT(10)    NOT NULL,
    stockQuantity  INT(10)      NOT NULL DEFAULT 0,
    description    VARCHAR(255),
    image          VARCHAR(255),
    tblCategory9id INT(10) NOT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (tblCategory9id) REFERENCES tblCategory9(id)
);

CREATE TABLE tblSupplierProduct9 (
    id             INT(10) AUTO_INCREMENT PRIMARY KEY,
    supplyPrice    FLOAT(10) NOT NULL,
    tblSupplier9id INT(10) NOT NULL,
    tblProduct9id  INT(10) NOT NULL,
    CONSTRAINT fk_sp_supplier FOREIGN KEY (tblSupplier9id) REFERENCES tblSupplier9(id),
    CONSTRAINT fk_sp_product  FOREIGN KEY (tblProduct9id)  REFERENCES tblProduct9(id)
);

-- ---------- Nhap hang ----------
CREATE TABLE tblImportReceipt9 (
    id             INT(10) AUTO_INCREMENT PRIMARY KEY,
    receiptCode    VARCHAR(50) NOT NULL UNIQUE,
    importDate     DATE NOT NULL,
    tblSupplier9id INT(10) NOT NULL,
    tblStaff9id    INT(10) NOT NULL,
    CONSTRAINT fk_receipt_supplier FOREIGN KEY (tblSupplier9id) REFERENCES tblSupplier9(id),
    CONSTRAINT fk_receipt_staff    FOREIGN KEY (tblStaff9id)    REFERENCES tblStaff9(tblMember9id)
);

CREATE TABLE tblImportReceiptDetail9 (
    id                  INT(10) AUTO_INCREMENT PRIMARY KEY,
    quantity            INT(10)   NOT NULL,
    importPrice         FLOAT(10) NOT NULL,
    tblImportReceipt9id INT(10) NOT NULL,
    tblProduct9id       INT(10) NOT NULL,
    CONSTRAINT fk_ird_receipt FOREIGN KEY (tblImportReceipt9id) REFERENCES tblImportReceipt9(id),
    CONSTRAINT fk_ird_product FOREIGN KEY (tblProduct9id)       REFERENCES tblProduct9(id)
);

-- ---------- Hoa don ban, trang thai ----------
CREATE TABLE tblInvoice9 (
    id              INT(10) AUTO_INCREMENT PRIMARY KEY,
    invoiceCode     VARCHAR(50) NOT NULL UNIQUE,
    orderDate       DATE NOT NULL,
    deliveryAddress VARCHAR(255),
    tblCustomer9id  INT(10) NOT NULL,
    tblStaff9id     INT(10) NULL,
    CONSTRAINT fk_invoice_customer FOREIGN KEY (tblCustomer9id) REFERENCES tblCustomer9(tblMember9id),
    CONSTRAINT fk_invoice_staff    FOREIGN KEY (tblStaff9id)    REFERENCES tblStaff9(tblMember9id)
);

CREATE TABLE tblInvoiceDetail9 (
    id            INT(10) AUTO_INCREMENT PRIMARY KEY,
    quantity      INT(10)   NOT NULL,
    sellingPrice  FLOAT(10) NOT NULL,
    tblInvoice9id INT(10) NOT NULL,
    tblProduct9id INT(10) NOT NULL,
    UNIQUE KEY uq_invoice_product (tblInvoice9id, tblProduct9id),
    CONSTRAINT fk_detail_invoice FOREIGN KEY (tblInvoice9id) REFERENCES tblInvoice9(id),
    CONSTRAINT fk_detail_product FOREIGN KEY (tblProduct9id) REFERENCES tblProduct9(id)
);

CREATE TABLE tblStatus9 (
    id   INT(10) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE tblStatusHistory9 (
    id            INT(10) AUTO_INCREMENT PRIMARY KEY,
    updateDate    DATE NOT NULL,
    tblInvoice9id INT(10) NOT NULL,
    tblStatus9id  INT(10) NOT NULL,
    CONSTRAINT fk_sh_invoice FOREIGN KEY (tblInvoice9id) REFERENCES tblInvoice9(id),
    CONSTRAINT fk_sh_status  FOREIGN KEY (tblStatus9id)  REFERENCES tblStatus9(id)
);

-- ================= DU LIEU MAU (mat khau cac tai khoan mau: Abc12345 - dat BR05) =================
INSERT IGNORE INTO tblMember9(username,password,fullName,birthDate,address,email,phone,role) VALUES
('manager',  SHA2('Abc12345',256),'Nguyễn Văn Quản','1985-03-12','Hà Nội',        'manager@shopman.vn', '0901000001','manager'),
('sales01',  SHA2('Abc12345',256),'Trần Thị Bán',   '1992-07-21','Hà Nội',        'sales01@shopman.vn', '0901000002','sales'),
('khach01',  SHA2('Abc12345',256),'Lê Văn An',      '1995-01-15','Hà Đông, Hà Nội','khach01@example.com','0912000001','customer'),
('khach02',  SHA2('Abc12345',256),'Phạm Thị Bình',  '1998-09-30','Cầu Giấy, Hà Nội','khach02@example.com','0912000002','customer'),
('khach03',  SHA2('Abc12345',256),'Hoàng Minh Châu','1990-05-05','Thanh Xuân, Hà Nội','khach03@example.com','0912000003','customer');

INSERT IGNORE INTO tblStaff9(tblMember9id,staffCode,position)
SELECT id,'NV001','manager' FROM tblMember9 WHERE username='manager';
INSERT IGNORE INTO tblStaff9(tblMember9id,staffCode,position)
SELECT id,'NV002','sales' FROM tblMember9 WHERE username='sales01';

INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate)
SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-01-10' FROM tblMember9 WHERE username='khach01';
INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate)
SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-02-14' FROM tblMember9 WHERE username='khach02';
INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate)
SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-03-20' FROM tblMember9 WHERE username='khach03';

INSERT IGNORE INTO tblCategory9(name,description) VALUES
('Thực phẩm','Gạo, dầu ăn, mì, đường'),
('Đồ uống','Nước ngọt, sữa'),
('Gia dụng','Nước rửa chén, bột giặt');

INSERT IGNORE INTO tblProduct9(productCode,name,sellingPrice,stockQuantity,description,tblCategory9id)
SELECT v.code, v.name, v.price, v.stock, v.descr, c.id
FROM (
  SELECT 'SP001' code,'Gạo ST25 túi 5kg' name,135000 price,120 stock,'Gạo thơm đặc sản, túi 5kg' descr,'Thực phẩm' cat
  UNION ALL SELECT 'SP002','Dầu ăn Neptune 1 lít',52000,200,'Dầu ăn tinh luyện chai 1 lít','Thực phẩm'
  UNION ALL SELECT 'SP003','Mì Hảo Hảo thùng 30 gói',115000,80,'Mì tôm chua cay, thùng 30 gói','Thực phẩm'
  UNION ALL SELECT 'SP004','Nước ngọt Coca-Cola thùng 24 lon',195000,60,'Thùng 24 lon 330ml','Đồ uống'
  UNION ALL SELECT 'SP005','Sữa tươi Vinamilk 1 lít',32000,150,'Sữa tươi tiệt trùng hộp 1 lít','Đồ uống'
  UNION ALL SELECT 'SP006','Nước rửa chén Sunlight 750ml',38000,90,'Chai 750ml hương chanh','Gia dụng'
  UNION ALL SELECT 'SP007','Bột giặt OMO 3kg',168000,45,'Túi 3kg giặt tay và giặt máy','Gia dụng'
  UNION ALL SELECT 'SP008','Đường tinh luyện 1kg',24000,70,'Đường trắng tinh luyện gói 1kg','Thực phẩm'
) v JOIN tblCategory9 c ON c.name = v.cat;

INSERT IGNORE INTO tblInvoice9(invoiceCode,orderDate,deliveryAddress,tblCustomer9id,tblStaff9id)
SELECT v.code, v.od, v.addr, c.id, s.id
FROM (
  SELECT 'HD001' code,'2026-09-05' od,'Hà Đông, Hà Nội' addr,'khach01' cu
  UNION ALL SELECT 'HD002','2026-09-18','Cầu Giấy, Hà Nội','khach02'
  UNION ALL SELECT 'HD003','2026-09-29','Thanh Xuân, Hà Nội','khach03'
  UNION ALL SELECT 'HD004','2026-10-03','Hà Đông, Hà Nội','khach01'
  UNION ALL SELECT 'HD005','2026-10-10','Cầu Giấy, Hà Nội','khach02'
  UNION ALL SELECT 'HD006','2026-10-15','Thanh Xuân, Hà Nội','khach03'
  UNION ALL SELECT 'HD007','2026-10-22','Hà Đông, Hà Nội','khach01'
  UNION ALL SELECT 'HD008','2026-10-28','Cầu Giấy, Hà Nội','khach02'
  UNION ALL SELECT 'HD009','2026-11-02','Thanh Xuân, Hà Nội','khach03'
  UNION ALL SELECT 'HD010','2026-11-05','Hà Đông, Hà Nội','khach01'
  UNION ALL SELECT 'HD011','2026-11-09','Cầu Giấy, Hà Nội','khach02'
  UNION ALL SELECT 'HD012','2026-11-12','Thanh Xuân, Hà Nội','khach03'
) v
JOIN tblMember9 c ON c.username = v.cu
JOIN (SELECT id FROM tblMember9 WHERE username='sales01') s;

INSERT IGNORE INTO tblInvoiceDetail9(tblInvoice9id,tblProduct9id,quantity,sellingPrice)
SELECT i.id, p.id, d.qty, p.sellingPrice
FROM (
  SELECT 'HD001' ic,'SP001' pc,2 qty UNION ALL SELECT 'HD001','SP002',1
  UNION ALL SELECT 'HD002','SP003',5 UNION ALL SELECT 'HD002','SP004',2
  UNION ALL SELECT 'HD003','SP001',1 UNION ALL SELECT 'HD003','SP005',6
  UNION ALL SELECT 'HD004','SP002',3 UNION ALL SELECT 'HD004','SP006',2
  UNION ALL SELECT 'HD005','SP001',3 UNION ALL SELECT 'HD005','SP007',1
  UNION ALL SELECT 'HD006','SP004',3 UNION ALL SELECT 'HD006','SP005',4
  UNION ALL SELECT 'HD007','SP003',4 UNION ALL SELECT 'HD007','SP001',2
  UNION ALL SELECT 'HD008','SP007',2 UNION ALL SELECT 'HD008','SP006',3
  UNION ALL SELECT 'HD009','SP001',4 UNION ALL SELECT 'HD009','SP002',2
  UNION ALL SELECT 'HD010','SP005',10 UNION ALL SELECT 'HD010','SP003',2
  UNION ALL SELECT 'HD011','SP004',1 UNION ALL SELECT 'HD011','SP001',1
  UNION ALL SELECT 'HD012','SP002',2 UNION ALL SELECT 'HD012','SP007',1
) d
JOIN tblInvoice9 i ON i.invoiceCode = d.ic
JOIN tblProduct9 p ON p.productCode = d.pc;

-- ================= DU LIEU BO SUNG =================
INSERT IGNORE INTO tblCategory9(name,description) VALUES
('Bánh kẹo','Bánh, kẹo, snack'),
('Gia vị','Nước mắm, muối, bột ngọt, tiêu'),
('Chăm sóc cá nhân','Dầu gội, sữa tắm, kem đánh răng'),
('Đồ dùng nhà bếp','Túi, màng bọc, giấy');

INSERT IGNORE INTO tblProduct9(productCode,name,sellingPrice,stockQuantity,description,tblCategory9id)
SELECT v.code,v.name,v.price,v.stock,v.descr,c.id FROM (
  SELECT 'SP009' code,'Bánh Oreo hộp 133g' name,18000 price,150 stock,'Bánh quy kem vani' descr,'Bánh kẹo' cat
  UNION ALL SELECT 'SP010','Snack Poca khoai tây 54g',9000,300,'Vị tự nhiên','Bánh kẹo'
  UNION ALL SELECT 'SP011','Kẹo Alpenliebe gói 120g',22000,120,'Kẹo sữa caramel','Bánh kẹo'
  UNION ALL SELECT 'SP012','Bánh Chocopie hộp 12 cái',58000,90,'Hộp 12 cái','Bánh kẹo'
  UNION ALL SELECT 'SP013','Nước mắm Chinsu chai 500ml',36000,140,'Nước mắm cá cơm','Gia vị'
  UNION ALL SELECT 'SP014','Muối i-ốt gói 500g',8000,200,'Muối tinh','Gia vị'
  UNION ALL SELECT 'SP015','Bột ngọt Ajinomoto gói 400g',32000,110,'Bột ngọt','Gia vị'
  UNION ALL SELECT 'SP016','Tiêu đen xay hũ 50g',28000,80,'Tiêu xay','Gia vị'
  UNION ALL SELECT 'SP017','Tương ớt Chinsu chai 250g',15000,160,'Tương ớt cay vừa','Gia vị'
  UNION ALL SELECT 'SP018','Dầu gội Clear 630g',165000,50,'Sạch gàu','Chăm sóc cá nhân'
  UNION ALL SELECT 'SP019','Sữa tắm Dove 530g',142000,55,'Dưỡng ẩm','Chăm sóc cá nhân'
  UNION ALL SELECT 'SP020','Kem đánh răng P/S 180g',34000,130,'Bảo vệ 123','Chăm sóc cá nhân'
  UNION ALL SELECT 'SP021','Bàn chải Oral-B vỉ 2 cái',45000,100,'Lông mềm','Chăm sóc cá nhân'
  UNION ALL SELECT 'SP022','Giấy vệ sinh Pulppy lốc 10 cuộn',78000,85,'Lốc 10 cuộn','Chăm sóc cá nhân'
  UNION ALL SELECT 'SP023','Túi rác tự hủy cuộn lớn',25000,120,'Cuộn 30 túi','Đồ dùng nhà bếp'
  UNION ALL SELECT 'SP024','Màng bọc thực phẩm 30m',32000,95,'Màng PE 30m','Đồ dùng nhà bếp'
  UNION ALL SELECT 'SP025','Giấy bạc nướng 5m',27000,70,'Cuộn 5m','Đồ dùng nhà bếp'
  UNION ALL SELECT 'SP026','Trà xanh Không Độ chai 455ml',10000,250,'Trà xanh đóng chai','Đồ uống'
  UNION ALL SELECT 'SP027','Nước suối Aquafina thùng 24 chai',85000,70,'Thùng 24 chai 500ml','Đồ uống'
  UNION ALL SELECT 'SP028','Bia Hà Nội thùng 24 lon',320000,40,'Thùng 24 lon 330ml','Đồ uống'
  UNION ALL SELECT 'SP029','Cà phê G7 3in1 hộp 21 gói',62000,100,'Hộp 21 gói','Đồ uống'
  UNION ALL SELECT 'SP030','Trà túi lọc Lipton hộp 25 gói',42000,90,'Trà đen','Đồ uống'
  UNION ALL SELECT 'SP031','Nước cam Tropicana 1 lít',48000,75,'Nước cam ép','Đồ uống'
  UNION ALL SELECT 'SP032','Gạo thơm Jasmine túi 10kg',250000,60,'Túi 10kg','Thực phẩm'
  UNION ALL SELECT 'SP033','Mì Omachi thùng 30 gói',230000,50,'Thùng 30 gói','Thực phẩm'
  UNION ALL SELECT 'SP034','Xúc xích Vissan gói 500g',65000,80,'Xúc xích tiệt trùng','Thực phẩm'
  UNION ALL SELECT 'SP035','Trứng gà vỉ 10 quả',35000,100,'Trứng gà ta','Thực phẩm'
  UNION ALL SELECT 'SP036','Nước giặt Ariel 3.6kg',215000,40,'Túi 3.6kg','Gia dụng'
  UNION ALL SELECT 'SP037','Nước xả Comfort 3.2 lít',132000,45,'Hương thanh xuân','Gia dụng'
  UNION ALL SELECT 'SP038','Nước lau sàn Sunlight 4kg',98000,50,'Chai 4kg','Gia dụng'
) v JOIN tblCategory9 c ON c.name = v.cat;

INSERT IGNORE INTO tblMember9(username,password,fullName,birthDate,address,email,phone,role) VALUES
('khach04',SHA2('Abc12345',256),'Vũ Thị Dung','1993-04-18','Nam Từ Liêm, Hà Nội','khach04@example.com','0912000004','customer'),
('khach05',SHA2('Abc12345',256),'Đặng Quốc Em','1988-11-02','Long Biên, Hà Nội','khach05@example.com','0912000005','customer'),
('khach06',SHA2('Abc12345',256),'Bùi Thu Phương','1996-06-25','Hoàng Mai, Hà Nội','khach06@example.com','0912000006','customer'),
('khach07',SHA2('Abc12345',256),'Ngô Văn Giang','1991-12-09','Hà Đông, Hà Nội','khach07@example.com','0912000007','customer'),
('khach08',SHA2('Abc12345',256),'Đỗ Thị Hạnh','1999-08-14','Tây Hồ, Hà Nội','khach08@example.com','0912000008','customer');

INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate) SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-01-05' FROM tblMember9 WHERE username='khach04';
INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate) SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-01-12' FROM tblMember9 WHERE username='khach05';
INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate) SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-02-03' FROM tblMember9 WHERE username='khach06';
INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate) SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-02-20' FROM tblMember9 WHERE username='khach07';
INSERT IGNORE INTO tblCustomer9(tblMember9id,customerCode,registerDate) SELECT id,CONCAT('KH',LPAD(id,5,'0')),'2026-03-08' FROM tblMember9 WHERE username='khach08';

DROP TEMPORARY TABLE IF EXISTS tmp_inv;
DROP TEMPORARY TABLE IF EXISTS tmp_det;
CREATE TEMPORARY TABLE tmp_inv (code VARCHAR(20), od DATE, addr VARCHAR(255), cu VARCHAR(50));
CREATE TEMPORARY TABLE tmp_det (ic VARCHAR(20), pc VARCHAR(20), qty INT);
INSERT INTO tmp_inv VALUES
('HD101','2026-01-06','Hà Đông, Hà Nội','khach01'),
('HD102','2026-01-08','Nam Từ Liêm, Hà Nội','khach04'),
('HD103','2026-01-10','Thanh Xuân, Hà Nội','khach03'),
('HD104','2026-01-14','Nam Từ Liêm, Hà Nội','khach04'),
('HD105','2026-01-17','Cầu Giấy, Hà Nội','khach02'),
('HD106','2026-01-23','Thanh Xuân, Hà Nội','khach03'),
('HD107','2026-01-28','Long Biên, Hà Nội','khach05'),
('HD108','2026-02-01','Hoàng Mai, Hà Nội','khach06'),
('HD109','2026-02-11','Hà Đông, Hà Nội','khach07'),
('HD110','2026-02-13','Tây Hồ, Hà Nội','khach08'),
('HD111','2026-02-14','Hà Đông, Hà Nội','khach01'),
('HD112','2026-02-17','Tây Hồ, Hà Nội','khach08'),
('HD113','2026-02-22','Long Biên, Hà Nội','khach05'),
('HD114','2026-02-24','Thanh Xuân, Hà Nội','khach03'),
('HD115','2026-02-24','Nam Từ Liêm, Hà Nội','khach04'),
('HD116','2026-02-26','Tây Hồ, Hà Nội','khach08'),
('HD117','2026-02-28','Cầu Giấy, Hà Nội','khach02'),
('HD118','2026-03-04','Nam Từ Liêm, Hà Nội','khach04'),
('HD119','2026-03-05','Thanh Xuân, Hà Nội','khach03'),
('HD120','2026-03-07','Tây Hồ, Hà Nội','khach08'),
('HD121','2026-03-11','Hà Đông, Hà Nội','khach07'),
('HD122','2026-03-12','Tây Hồ, Hà Nội','khach08'),
('HD123','2026-03-28','Hà Đông, Hà Nội','khach07'),
('HD124','2026-03-28','Thanh Xuân, Hà Nội','khach03'),
('HD125','2026-03-30','Nam Từ Liêm, Hà Nội','khach04'),
('HD126','2026-04-01','Nam Từ Liêm, Hà Nội','khach04'),
('HD127','2026-04-03','Cầu Giấy, Hà Nội','khach02'),
('HD128','2026-04-04','Hà Đông, Hà Nội','khach01'),
('HD129','2026-04-16','Nam Từ Liêm, Hà Nội','khach04'),
('HD130','2026-04-27','Hà Đông, Hà Nội','khach01'),
('HD131','2026-05-04','Thanh Xuân, Hà Nội','khach03'),
('HD132','2026-05-09','Nam Từ Liêm, Hà Nội','khach04'),
('HD133','2026-05-11','Cầu Giấy, Hà Nội','khach02'),
('HD134','2026-05-12','Long Biên, Hà Nội','khach05'),
('HD135','2026-05-17','Hà Đông, Hà Nội','khach01'),
('HD136','2026-05-20','Long Biên, Hà Nội','khach05'),
('HD137','2026-05-26','Hà Đông, Hà Nội','khach01'),
('HD138','2026-06-02','Thanh Xuân, Hà Nội','khach03'),
('HD139','2026-06-03','Hoàng Mai, Hà Nội','khach06'),
('HD140','2026-06-04','Hà Đông, Hà Nội','khach07'),
('HD141','2026-06-10','Tây Hồ, Hà Nội','khach08'),
('HD142','2026-06-19','Hà Đông, Hà Nội','khach01'),
('HD143','2026-06-26','Hà Đông, Hà Nội','khach07'),
('HD144','2026-06-29','Hà Đông, Hà Nội','khach01'),
('HD145','2026-06-30','Thanh Xuân, Hà Nội','khach03'),
('HD146','2026-07-03','Long Biên, Hà Nội','khach05'),
('HD147','2026-07-14','Long Biên, Hà Nội','khach05'),
('HD148','2026-07-17','Hà Đông, Hà Nội','khach01'),
('HD149','2026-07-18','Tây Hồ, Hà Nội','khach08'),
('HD150','2026-07-22','Hoàng Mai, Hà Nội','khach06'),
('HD151','2026-07-23','Nam Từ Liêm, Hà Nội','khach04'),
('HD152','2026-07-23','Hà Đông, Hà Nội','khach01'),
('HD153','2026-07-26','Nam Từ Liêm, Hà Nội','khach04'),
('HD154','2026-07-26','Tây Hồ, Hà Nội','khach08'),
('HD155','2026-07-31','Hoàng Mai, Hà Nội','khach06'),
('HD156','2026-08-10','Tây Hồ, Hà Nội','khach08'),
('HD157','2026-08-18','Hà Đông, Hà Nội','khach07'),
('HD158','2026-08-19','Hà Đông, Hà Nội','khach07'),
('HD159','2026-08-19','Hoàng Mai, Hà Nội','khach06'),
('HD160','2026-08-24','Hoàng Mai, Hà Nội','khach06'),
('HD161','2026-08-26','Hà Đông, Hà Nội','khach01'),
('HD162','2026-08-26','Nam Từ Liêm, Hà Nội','khach04'),
('HD163','2026-08-28','Hoàng Mai, Hà Nội','khach06'),
('HD164','2026-08-28','Nam Từ Liêm, Hà Nội','khach04'),
('HD165','2026-08-31','Hà Đông, Hà Nội','khach01'),
('HD166','2026-09-04','Tây Hồ, Hà Nội','khach08'),
('HD167','2026-09-09','Hà Đông, Hà Nội','khach01'),
('HD168','2026-09-10','Long Biên, Hà Nội','khach05'),
('HD169','2026-09-15','Hà Đông, Hà Nội','khach07'),
('HD170','2026-09-16','Cầu Giấy, Hà Nội','khach02'),
('HD171','2026-09-19','Cầu Giấy, Hà Nội','khach02'),
('HD172','2026-09-19','Cầu Giấy, Hà Nội','khach02'),
('HD173','2026-09-20','Long Biên, Hà Nội','khach05'),
('HD174','2026-09-29','Long Biên, Hà Nội','khach05'),
('HD175','2026-10-04','Hà Đông, Hà Nội','khach07'),
('HD176','2026-10-07','Hà Đông, Hà Nội','khach01'),
('HD177','2026-10-08','Long Biên, Hà Nội','khach05'),
('HD178','2026-10-11','Hoàng Mai, Hà Nội','khach06'),
('HD179','2026-10-11','Cầu Giấy, Hà Nội','khach02'),
('HD180','2026-10-11','Long Biên, Hà Nội','khach05'),
('HD181','2026-10-12','Hoàng Mai, Hà Nội','khach06'),
('HD182','2026-10-16','Hà Đông, Hà Nội','khach07'),
('HD183','2026-10-20','Hà Đông, Hà Nội','khach01'),
('HD184','2026-10-27','Long Biên, Hà Nội','khach05'),
('HD185','2026-10-28','Cầu Giấy, Hà Nội','khach02'),
('HD186','2026-10-30','Tây Hồ, Hà Nội','khach08'),
('HD187','2026-11-05','Hà Đông, Hà Nội','khach07'),
('HD188','2026-11-07','Hà Đông, Hà Nội','khach07'),
('HD189','2026-11-11','Nam Từ Liêm, Hà Nội','khach04'),
('HD190','2026-11-14','Nam Từ Liêm, Hà Nội','khach04');
INSERT INTO tmp_det VALUES
('HD101','SP001',1),
('HD101','SP011',8),
('HD101','SP021',6),
('HD101','SP024',9),
('HD101','SP036',1),
('HD102','SP004',5),
('HD102','SP007',5),
('HD102','SP008',7),
('HD102','SP013',8),
('HD102','SP031',4),
('HD103','SP002',10),
('HD103','SP006',6),
('HD103','SP019',4),
('HD103','SP027',10),
('HD103','SP038',5),
('HD104','SP001',3),
('HD104','SP012',5),
('HD104','SP020',2),
('HD105','SP001',1),
('HD105','SP012',6),
('HD105','SP021',5),
('HD105','SP029',1),
('HD105','SP036',2),
('HD106','SP001',5),
('HD106','SP009',2),
('HD106','SP011',3),
('HD106','SP013',6),
('HD106','SP018',5),
('HD107','SP006',8),
('HD107','SP011',12),
('HD108','SP001',1),
('HD108','SP003',2),
('HD108','SP011',7),
('HD108','SP030',4),
('HD108','SP032',1),
('HD109','SP001',4),
('HD109','SP004',3),
('HD109','SP011',3),
('HD109','SP038',4),
('HD110','SP011',7),
('HD110','SP012',9),
('HD110','SP027',3),
('HD110','SP032',4),
('HD110','SP034',4),
('HD111','SP001',2),
('HD111','SP007',1),
('HD111','SP018',3),
('HD112','SP011',8),
('HD112','SP027',1),
('HD112','SP032',4),
('HD113','SP008',10),
('HD113','SP009',3),
('HD113','SP018',2),
('HD113','SP022',5),
('HD114','SP001',3),
('HD114','SP004',4),
('HD114','SP005',8),
('HD114','SP006',3),
('HD114','SP034',6),
('HD115','SP009',10),
('HD115','SP016',2),
('HD116','SP004',5),
('HD116','SP011',5),
('HD116','SP021',10),
('HD116','SP029',11),
('HD116','SP036',1),
('HD117','SP010',1),
('HD117','SP012',4),
('HD117','SP018',1),
('HD118','SP011',10),
('HD118','SP031',10),
('HD118','SP032',2),
('HD119','SP008',11),
('HD119','SP011',1),
('HD120','SP008',5),
('HD120','SP013',5),
('HD120','SP014',12),
('HD120','SP023',9),
('HD120','SP036',3),
('HD121','SP007',3),
('HD121','SP021',10),
('HD122','SP023',4),
('HD122','SP032',5),
('HD123','SP001',2),
('HD123','SP018',2),
('HD124','SP020',3),
('HD124','SP027',11),
('HD124','SP036',3),
('HD125','SP009',10),
('HD125','SP032',5),
('HD126','SP012',7),
('HD126','SP021',5),
('HD126','SP034',4),
('HD126','SP036',1),
('HD127','SP001',2),
('HD127','SP011',9),
('HD127','SP018',4),
('HD127','SP032',2),
('HD128','SP011',12),
('HD128','SP018',4),
('HD128','SP034',7),
('HD129','SP004',5),
('HD129','SP011',9),
('HD129','SP025',10),
('HD129','SP033',3),
('HD130','SP001',2),
('HD130','SP032',5),
('HD130','SP033',1),
('HD131','SP014',1),
('HD131','SP016',11),
('HD131','SP018',2),
('HD131','SP037',1),
('HD132','SP032',4),
('HD132','SP034',4),
('HD133','SP023',7),
('HD133','SP036',3),
('HD134','SP021',2),
('HD134','SP027',12),
('HD135','SP025',12),
('HD135','SP032',3),
('HD135','SP033',1),
('HD136','SP001',4),
('HD136','SP021',1),
('HD136','SP025',10),
('HD137','SP013',3),
('HD137','SP021',8),
('HD137','SP035',8),
('HD138','SP001',5),
('HD138','SP002',9),
('HD138','SP011',11),
('HD138','SP021',9),
('HD138','SP036',2),
('HD139','SP005',8),
('HD139','SP013',10),
('HD139','SP015',3),
('HD139','SP018',4),
('HD140','SP018',1),
('HD140','SP024',1),
('HD141','SP001',4),
('HD141','SP004',2),
('HD141','SP029',10),
('HD141','SP030',1),
('HD141','SP037',1),
('HD142','SP011',2),
('HD142','SP018',1),
('HD142','SP036',4),
('HD143','SP005',10),
('HD143','SP018',5),
('HD144','SP004',5),
('HD144','SP007',5),
('HD144','SP010',8),
('HD144','SP011',10),
('HD144','SP022',11),
('HD145','SP001',3),
('HD145','SP008',5),
('HD145','SP018',3),
('HD145','SP027',12),
('HD145','SP036',1),
('HD146','SP004',4),
('HD146','SP009',4),
('HD146','SP032',1),
('HD147','SP006',1),
('HD147','SP011',12),
('HD147','SP015',6),
('HD147','SP018',3),
('HD148','SP001',2),
('HD148','SP004',1),
('HD148','SP011',8),
('HD148','SP014',2),
('HD149','SP013',9),
('HD149','SP036',5),
('HD149','SP037',3),
('HD150','SP001',1),
('HD150','SP006',10),
('HD150','SP018',1),
('HD150','SP026',3),
('HD150','SP029',8),
('HD151','SP001',3),
('HD151','SP004',5),
('HD151','SP034',4),
('HD152','SP001',1),
('HD152','SP018',5),
('HD152','SP033',4),
('HD152','SP036',3),
('HD153','SP001',1),
('HD153','SP021',8),
('HD153','SP025',5),
('HD153','SP032',3),
('HD153','SP037',1),
('HD154','SP009',9),
('HD154','SP013',5),
('HD155','SP001',4),
('HD155','SP002',8),
('HD155','SP012',11),
('HD155','SP024',3),
('HD156','SP001',1),
('HD156','SP032',1),
('HD156','SP038',12),
('HD157','SP001',4),
('HD157','SP004',1),
('HD157','SP011',8),
('HD157','SP030',8),
('HD158','SP003',1),
('HD158','SP004',3),
('HD158','SP009',3),
('HD158','SP018',5),
('HD158','SP032',5),
('HD159','SP011',4),
('HD159','SP032',1),
('HD159','SP038',10),
('HD160','SP012',2),
('HD160','SP034',2),
('HD161','SP001',2),
('HD161','SP002',2),
('HD161','SP006',10),
('HD161','SP009',7),
('HD161','SP013',7),
('HD162','SP007',2),
('HD162','SP008',9),
('HD162','SP012',9),
('HD162','SP034',4),
('HD163','SP014',9),
('HD163','SP021',9),
('HD163','SP032',2),
('HD164','SP004',4),
('HD164','SP005',7),
('HD164','SP019',1),
('HD165','SP001',4),
('HD165','SP004',3),
('HD165','SP006',10),
('HD165','SP011',3),
('HD166','SP001',4),
('HD166','SP014',4),
('HD166','SP021',3),
('HD167','SP001',1),
('HD167','SP031',3),
('HD167','SP034',8),
('HD168','SP001',2),
('HD168','SP013',10),
('HD168','SP014',8),
('HD168','SP032',3),
('HD168','SP036',2),
('HD169','SP009',4),
('HD169','SP011',9),
('HD170','SP009',11),
('HD170','SP017',2),
('HD170','SP032',1),
('HD171','SP001',1),
('HD171','SP007',5),
('HD171','SP021',8),
('HD171','SP036',2),
('HD171','SP037',5),
('HD172','SP012',9),
('HD172','SP018',2),
('HD172','SP033',4),
('HD172','SP035',3),
('HD173','SP014',6),
('HD173','SP016',2),
('HD173','SP034',12),
('HD173','SP036',3),
('HD173','SP037',4),
('HD174','SP011',6),
('HD174','SP018',1),
('HD174','SP029',12),
('HD175','SP004',5),
('HD175','SP007',3),
('HD175','SP025',3),
('HD175','SP034',2),
('HD176','SP034',8),
('HD176','SP036',2),
('HD177','SP017',4),
('HD177','SP034',12),
('HD178','SP005',1),
('HD178','SP006',4),
('HD178','SP007',1),
('HD178','SP018',2),
('HD179','SP003',1),
('HD179','SP004',2),
('HD179','SP025',2),
('HD179','SP035',11),
('HD179','SP037',1),
('HD180','SP002',6),
('HD180','SP008',11),
('HD180','SP011',3),
('HD180','SP027',12),
('HD181','SP001',3),
('HD181','SP003',1),
('HD181','SP011',7),
('HD181','SP014',6),
('HD181','SP029',6),
('HD182','SP001',3),
('HD182','SP004',5),
('HD182','SP009',7),
('HD182','SP016',7),
('HD183','SP003',2),
('HD183','SP009',11),
('HD183','SP018',4),
('HD184','SP004',3),
('HD184','SP007',4),
('HD184','SP024',6),
('HD184','SP036',1),
('HD185','SP004',1),
('HD185','SP014',1),
('HD185','SP025',11),
('HD185','SP032',5),
('HD185','SP037',1),
('HD186','SP011',10),
('HD186','SP027',10),
('HD186','SP036',5),
('HD187','SP001',5),
('HD187','SP018',3),
('HD187','SP034',1),
('HD188','SP004',5),
('HD188','SP024',8),
('HD189','SP013',12),
('HD189','SP032',4),
('HD190','SP003',1),
('HD190','SP011',10),
('HD190','SP017',4),
('HD190','SP029',2),
('HD190','SP034',1);

INSERT IGNORE INTO tblInvoice9(invoiceCode,orderDate,deliveryAddress,tblCustomer9id,tblStaff9id)
SELECT t.code,t.od,t.addr,c.id,s.id
FROM tmp_inv t
JOIN tblMember9 c ON c.username = t.cu
JOIN (SELECT id FROM tblMember9 WHERE username='sales01') s;

INSERT IGNORE INTO tblInvoiceDetail9(tblInvoice9id,tblProduct9id,quantity,sellingPrice)
SELECT i.id,p.id,d.qty,p.sellingPrice
FROM tmp_det d
JOIN tblInvoice9 i ON i.invoiceCode = d.ic
JOIN tblProduct9 p ON p.productCode = d.pc;

DROP TEMPORARY TABLE IF EXISTS tmp_inv;
DROP TEMPORARY TABLE IF EXISTS tmp_det;

-- ================= HINH ANH MAT HANG (thu muc webapp/images) =================
UPDATE tblProduct9 SET image = CONCAT('images/', productCode, '.png');

-- ================= TRANG THAI HOA DON (FR06-FR10) =================
INSERT INTO tblStatus9(name) VALUES
('Chờ duyệt'),('Đã duyệt'),('Đang đóng gói'),('Đang giao'),('Đã giao'),('Đã hủy');
