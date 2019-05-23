/*
 * For some people with special background whose name may be not in the normal pattern,
 * IDNumber stores the ID Type(eg. BCID, Passport) and the number
 * store their full name in fName.
 */
CREATE TABLE Customer(
    username VARCHAR(12) PRIMARY KEY,
    password VARCHAR(16) NOT NULL,
    IDNumber VARCHAR(32) NOT NULL,
    lName    VARCHAR(32)
    fName    VARCHAR(32) NOT NULL,
    phoneNum CHAR(10) NOT NULL,
    address  VARCHAR(128) NOT NULL,
    email    VARCHAR(64),
    UNIQUE(IDNum, phoneNum, email)
);

/*
 * All the types are stored using a 4-character abbreviation.
 * rate is measured in CAD/day.
 */
CREATE TABLE ItemType(
    typeName CHAR(4) PRIMARY KEY,
    rate     INT
);

CREATE TABLE Branch(
    branchID INTEGER(5) PRIMARY KEY,
    address  VARCHAR(128) NOT NULL,
    phoneNum CHAR(10) NOT NULL,
    UNIQUE(address, phoneNum)
);

CREATE TABLE Employee(
    employID INTEGER(4) AUTO_INCREMENT,
    lName    VARCHAR(32),
    fName    VARCHAR(32) NOT NULL,
    SINNum   INTEGER(10) NOT NULL,
    phoneNum CHAR(10) NOT NULL,
    email    VARCHAR(64) NOT NULL,
    address  VARCHAR(128) NOT NULL,
    PRIMARY KEY(employID),
    UNIQUE(SINNum, phoneNum, email)
);

CREATE TABLE Manager(
    employID INTEGER(4) PRIMARY KEY,
    username VARCHAR(12) UNIQUE NOT NULL,
    password VARCHAR(16) NOT NULL,
    branchID INTEGER(5) UNIQUE NOT NULL,
    FOREIGN KEY(employID) REFERENCES Employee(employID)
  			ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES Branch(branchID)
  			ON DELETE CASCADE /* TODO */
        ON UPDATE CASCADE
);

/* 
 * innerPIN is the password for the labor to enter a storeroom
 */
CREATE TABLE Labourer(
    employID INTEGER(4) PRIMARY KEY,
    innerPIN INTEGER(4) UNIQUE,
    branchID INTEGER(5),
    FOREIGN KEY(employID) REFERENCES Employee(employID)
  			ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES Branch(branchID)
  			ON DELETE CASCADE
        ON UPDATE CASCADE
);

/*
 * the storage does not accept cash.
 * method is stored using 4-character abbreviation (eg. Debit -> DBIT)
 * amount is measured using CAD
 */
CREATE TABLE Payment(
    payNum   INTEGER(8) AUTO_INCREMENT,
    amount   REAL NOT NULL,
    cardNum  CHAR(16),
    PRIMARY KEY(payNum),
    FOREIGN KEY (cardNum) REFERENCES Card(cardNum)
);

CREATE TABLE Card(
		cardNum CHAR(16) PRIMARY KEY,
    cardExp DATE,
  	method  CHAR(4)  
);

/* 
 * no refund 
 */
CREATE TABLE Agreement(
    agrmtNum INTEGER(8) AUTO_INCREMENT,
    startDay DATE NOT NULL,
    endDay   DATE NOT NULL,
    payment  INTEGER(8) UNIQUE NOT NULL,
  	pickDay  DATE,
    fromResv INTEGER(8) UNIQUE,
    PRIMARY KEY(agrmtNum),
    FOREIGN KEY(payment) REFERENCES Payment(payNum)
        ON UPDATE CASCADE,
    FOREIGN KEY(fromResv) REFERENCES Reservation(confNum)
        ON UPDATE CASCADE,
);

CREATE TABLE Storeroom(
    roomNum  INTEGER(3),
    branchID INTEGER(5),
    maxSpace REAL NOT NULL,
    freSpace REAL NOT NULL,
    PRIMARY KEY(roomNum, branchID),
    FOREIGN KEY(branchID) REFERENCES Branch(branchID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/*
 * size is measured using meter^3
 */
CREATE TABLE Item(
    itemNum  INT(12) AUTO_INCREMENT,
    agrmtNum INTEGER(12) NOT NULL,
    size     REAL NOT NULL,
    PRIMARY KEY(itemNum),
		FOREIGN KEY(agrmtNum) REFERENCES Agreement(agrmtNum) 
  			ON UPDATE CASCADE
);

CREATE TABLE ItemInfo(
  	agrmtNum INTEGER(12) NOT NULL PRIMARY KEY,
		owner    VARCHAR(12) NOT NULL,
    branch   INTEGER(5) NOT NULL,
    roomNum  INTEGER(3) NOT NULL,
    FOREIGN KEY(owner) REFERENCES Customer(username) 
  			ON UPDATE CASCADE,
    FOREIGN KEY(agrmtNum) REFERENCES Agreement(agrmtNum) 
  			ON UPDATE CASCADE,
    FOREIGN KEY(branch) REFERENCES Branch(branchID) 
  			ON UPDATE CASCADE,
    FOREIGN KEY(roomNum) REFERENCES Storeroom(roomNUM) 
  			ON UPDATE CASCADE
);

CREATE TABLE ItemClass(
    itemNum  INT(12),
    typeName CHAR(4) DEFAULT 'RGLR',
    PRIMARY KEY(itemNUM, typeName),
    FOREIGN KEY(itemNum) REFERENCES Item(itemNUM)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(typeName) REFERENCES ItemType(typeName)
        ON UPDATE CASCADE
);

/*
 * rsvSpace is measured using meter^3
 */
CREATE TABLE Reservation(
    confNum  INTEGER(8) AUTO_INCREMENT,
    reserver VARCHAR(12) NOT NULL,
    startDay DATE NOT NULL,
    endDay   DATE NOT NULL,
    rsvSpace REAL NOT NULL,
    branch   INTEGER(5),
    roomNum  INTEGER(3),
    payment  INTEGER(8) NOT NULL,
    PRIMARY KEY(confNum),
    UNIQUE(payment),
    FOREIGN KEY(reserver) REFERENCES Customer(username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(branch) REFERENCES Branch(branchID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY(roomNUM) REFERENCES Storeroom(roomNUM)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY(payment) REFERENCES Payment(payNum)
        ON UPDATE CASCADE
);

CREATE TABLE Room_Type(
    roomNum  INTEGER(3),
    branchID INTEGER(5),
    typeName CHAR(4) DEFAULT 'RGLR',
    PRIMARY KEY(branchID, roomNum, typeName),
    FOREIGN KEY(roomNUM) REFERENCES Storeroom(roomNUM)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES Branch(branchID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(typeName) REFERENCES ItemType(typeName)
        ON UPDATE CASCADE
);

/*
 *this trigger is to make sure that all the Storeroom always has at least one type
 */
CREATE TRIGGER totalRoomClass AFTER INSERT ON Storeroom FOR EACH ROW
INSERT INTO Room_Type(roomNUM, branchID, typeName)
VALUES(new.roomNUM, new.branchID, 'RGLR');

/*
 *this trigger is to make sure that all the Item always has at least one type
 */
CREATE TRIGGER totalItemClass AFTER INSERT ON Item FOR EACH ROW
INSERT INTO ItemClass(itemNUM, typeName)
VALUES(new.itemNum, 'RGLR');


INSERT INTO Customer VALUES("ada728","19990728", "STUC88888888", "Tang", "Ada", "7783021185","888 61 St Vancouver", "tangadaa@hotmail,com");
INSERT INTO Customer VALUES("yixuan99", "19990316", "STUC95411336", "Qi", "YiXuan", "7788989567", "2127 W 21 Ave Vancouver", "yixuan99316@gmail.com");
INSERT INTO Customer VALUES("lizhe1313", "yxsy0102", "STUC88792486", "Li", "Zhe", "7785227568", "788-2205 Lower Mall, Vancouver","lizhe1313@outlook.com"); 
INSERT INTO Customer VALUES("me", "password", "8888", "Wong", "Justin", "7782888218", "2600 East Broadway Street, Vancouver, BC, V5B 1Y5", "justinc.s.wong@gmail.com"); 