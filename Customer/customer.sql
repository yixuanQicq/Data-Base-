CREATE TABLE Preference (Pref_ID CHAR(4), Pref_Name CHAR(30), PRIMARY KEY(Pref_ID));

CREATE TABLE Vendor (Vendor_ID INTEGER, Vendor_Name CHAR(30), PRIMARY KEY(Vendor_ID));

CREATE TABLE Customer (Customer_ID INTEGER, Customer_Name CHAR(30), Customer_Age INTEGER,Customer_City CHAR(30),Customer_Preference CHAR(4) DEFAULT 'PPPP', PRIMARY KEY(Customer_ID), UNIQUE(Customer_Age), FOREIGN KEY(Customer_Preference) REFERENCES Preference ON DELETE SET DEFAULT);

CREATE TABLE Sales_Order (Order_ID INTEGER,Order_Date DATE,Customer_ID INTEGER,PRIMARY KEY(Order_ID),FOREIGN KEY(Customer_ID) REFERENCES Customer ON DELETE CASCADE);

CREATE TABLE Products(Product_ID INTEGER,Product_Name CHAR(30),Standard_Price REAL,Vendor_ID INTEGER,PRIMARY KEY(Product_ID),FOREIGN KEY(Vendor_ID) REFERENCES Vendor ON DELETE SET NULL);

INSERT INTO Preference(Pref_ID, Pref_Name) VALUES ('P1','Cash on Delivery');
INSERT INTO Preference(Pref_ID, Pref_Name) VALUES ('P2','Online Payment');
INSERT INTO Preference(Pref_ID, Pref_Name) VALUES ('P3','Cash on Delivery');
INSERT INTO Preference(Pref_ID, Pref_Name) VALUES ('PPPP','Deleted Ones');

INSERT INTO Vendor(Vendor_ID,Vendor_Name) VALUES ('100','Titan');
INSERT INTO Vendor(Vendor_ID,Vendor_Name) VALUES ('200','ABC Manufacturers');

INSERT INTO Customer(Customer_ID, Customer_Name, Customer_Age, Customer_City, Customer_Preference) VALUES ('101','Simon Li','21','New York','P1');
INSERT INTO Customer(Customer_ID, Customer_Name, Customer_Age, Customer_City, Customer_Preference) VALUES ('102','Goldberg Smith','23','San Francisco','P2');
INSERT INTO Customer(Customer_ID, Customer_Name, Customer_Age, Customer_City, Customer_Preference) VALUES ('103','Richard Andrew','34','San Diego','P1');
INSERT INTO Customer(Customer_ID, Customer_Name, Customer_Age, Customer_Preference) VALUES ('104','Catherine Wong','27','P1');
INSERT INTO Customer(Customer_ID, Customer_Name, Customer_Age, Customer_City, Customer_Preference) VALUES ('105','Jamie','29','Vancouver','P3');

INSERT INTO Sales_Order(Order_ID,Order_Date,Customer_ID) VALUES ('200', '2018-01-11', '101');
INSERT INTO Sales_Order(Order_ID,Order_Date,Customer_ID) VALUES ('201', '2017-10-21', '102');
INSERT INTO Sales_Order(Order_ID,Order_Date,Customer_ID) VALUES ('202', '2016-05-04', '103');
INSERT INTO Sales_Order(Order_ID,Order_Date,Customer_ID) VALUES ('203', '2018-02-11', '102');

INSERT INTO Products(Product_ID, Product_Name, Standard_Price, Vendor_ID) VALUES ('1000','Office Desk','105','100');
INSERT INTO Products(Product_ID, Product_Name, Standard_Price, Vendor_ID) VALUES ('1001','Managers Desk','209.20','200');
INSERT INTO Products(Product_ID, Product_Name, Standard_Price, Vendor_ID) VALUES ('2000','Office Chair','89.40',NULL);
INSERT INTO Products(Product_ID, Product_Name, Standard_Price, Vendor_ID) VALUES ('2001','Managers Desk','229','100');
