---DROP ALL TABLES TO MAKE SURE THE SCHEMA IS CLEAR
DROP TABLE PROFILE CASCADE CONSTRAINTS;
DROP TABLE FRIENDS CASCADE CONSTRAINTS;
DROP TABLE PENDINGFRIENDS CASCADE CONSTRAINTS;
DROP TABLE GROUPS CASCADE CONSTRAINTS;
DROP TABLE GROUPMEMBERSHIP CASCADE CONSTRAINTS;
DROP TABLE PENDINGGROUPMEMBERS CASCADE CONSTRAINTS;
DROP TABLE MESSAGES CASCADE CONSTRAINTS;
DROP TABLE MESSAGERECIPIENT CASCADE CONSTRAINTS;

---CREATING PROFILE TABLE
CREATE TABLE PROFILE(
userID          varchar2(20)    not null deferrable,
name            varchar2(50)    not null deferrable,
email           varchar2(50)    not null deferrable,
password        varchar2(50)    not null deferrable,
date_of_birth   date,
lastlogin       timestamp,
CONSTRAINT PROFILE_PK PRIMARY KEY (userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PROFILE_UN UNIQUE(email) INITIALLY IMMEDIATE DEFERRABLE
); 

---CREATING FRIENDS TABLE
CREATE TABLE FRIENDS(
userID1     varchar2(20)    not null deferrable,
userID2     varchar2(20)    not null deferrable,
JDate       date            not null deferrable,
message     varchar2(200),
CONSTRAINT FRIENDS_USER_CH CHECK (userID1<>userID2) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT FRIENDS_PK PRIMARY KEY (userID1, userID2) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT FRIENDS_FK1 FOREIGN KEY (userID1) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT FRIENDS_FK2 FOREIGN KEY (userID2) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING PENDINGFRIENDS TABLE
CREATE TABLE PENDINGFRIENDS(
fromID      varchar2(20)    not null deferrable,
toID        varchar2(20)    not null deferrable,
message     varchar2(200),
CONSTRAINT PENDINGFRIENDS_CH CHECK (fromID<>toID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGFRIENDS_PK PRIMARY KEY (fromID, toID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGFRIENDS_FK1 FOREIGN KEY (fromID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGFRIENDS_FK2 FOREIGN KEY (toID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
); 

---CREATING GROUPS TABLE
CREATE TABLE GROUPS(
gID           varchar2(20)    not null deferrable,
name          varchar2(50)    not null deferrable,
description   varchar2(200)   default null,
limit         number(5)       default null,
CONSTRAINT PROFILE_CH CHECK (gID>0) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT GROUPS_PK PRIMARY KEY (gID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING GROUPMEMBERSHIP TABLE
CREATE TABLE GROUPMEMBERSHIP(
gID         varchar2(20)    not null deferrable,
userID      varchar2(50)    not null deferrable,
role        varchar2(20)    default('member'),
CONSTRAINT GROUPMEMBERSHIP_PK PRIMARY KEY (gID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT GROUPMEMBERSHIP_FK1 FOREIGN KEY (gID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT GROUPMEMBERSHIP_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING PENDINGGROUPMEMBERS TABLE
CREATE TABLE PENDINGGROUPMEMBERS(
gID         varchar2(20)    not null deferrable,
userID      varchar2(20)    not null deferrable,
message     varchar2(200)   default null, 
CONSTRAINT PENDINGGROUPMEMBERS_PK PRIMARY KEY (gID, userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGGROUPMEMBERS_FK1 FOREIGN KEY (gID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGGROUPMEMBERS_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING MESSAGES TABLE
CREATE TABLE MESSAGES(
msgID       varchar2(20)    not null deferrable,
fromID      varchar2(20)    not null deferrable,  
message     varchar2(200)   default null,
toUserID    varchar2(20)    default null,
toGroupID   varchar2(20)    default null,
dateSent    date            not null deferrable,
CONSTRAINT MESSAGES_USER_CH CHECK (fromID<>toUserID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT MESSAGES_PK PRIMARY KEY (msgID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT MESSAGES_FK1 FOREIGN KEY (fromID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT MESSAGES_FK2 FOREIGN KEY (toUserID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT MESSAGES_FK3 FOREIGN KEY (toGroupID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING MESSAGERECIPIENT TABLE
CREATE TABLE MESSAGERECIPIENT(
msgID       varchar2(20)     not null deferrable,
userID      varchar2(20),
CONSTRAINT MESSAGERECIPIENT_PK PRIMARY KEY (msgID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT MESSAGERECIPIENT_FK1 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT MESSAGERECIPIENT_FK2 FOREIGN KEY (msgID) REFERENCES MESSAGES(msgID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING PENDINGFRIENDS TRIGGER
CREATE OR REPLACE TRIGGER friends_constraint_trigger
AFTER INSERT OR UPDATE
ON PENDINGFRIENDS
FOR EACH ROW
BEGIN
    FOR X IN (SELECT * FROM DUAL WHERE 
         EXISTS(SELECT * 
	     FROM FRIENDS f
	     WHERE (f.userID1 = :new.fromID AND f.userID2 = :new.toID) OR (f.userID2 = :new.fromID AND f.userID1 = :new.toID)))
    LOOP
        Raise_Application_Error (-20001, 'These users are already friends');
    END LOOP;
END;
/

---CREATING PENDINGGROUPMEMBERS TRIGGER
CREATE OR REPLACE TRIGGER memberships_constraint_trigger
AFTER INSERT OR UPDATE of userID ON PENDINGGROUPMEMBERS
FOR EACH ROW
BEGIN
    FOR X IN (SELECT * FROM DUAL WHERE 
            EXISTS(SELECT g.userID 
            FROM GROUPMEMBERSHIP g
            WHERE g.gID = :NEW.gID AND g.userID = :NEW.userID))
    LOOP 
        Raise_Application_Error (-20002, 'This user is already in this group');
    END LOOP;
END;
/

---GENERATE USER PROFILE DATA
INSERT INTO PROFILE values('hjh84', 'Ariel', 'hjh84@gmail.com', 'pass', '25-MAY-1976', null);
INSERT INTO PROFILE values('hwp59', 'Stefania', 'hwp59@gmail.com', 'pass', '26-SEP-1970', null);
INSERT INTO PROFILE values('stb41', 'Julian', 'stb41@gmail.com', 'pass', '12-JAN-1989', null);
INSERT INTO PROFILE values('atz36', 'Susan', 'atz36@gmail.com', 'pass', '13-JAN-1976', null);
INSERT INTO PROFILE values('ssc60', 'Bernardina', 'ssc60@gmail.com', 'pass', '19-FEB-1968', null);
INSERT INTO PROFILE values('hru38', 'Esta', 'hru38@gmail.com', 'pass', '17-MAY-1991', null);
INSERT INTO PROFILE values('bif47', 'Lavelle', 'bif47@gmail.com', 'pass', '25-AUG-1962', null);
INSERT INTO PROFILE values('bhf42', 'Francis', 'bhf42@gmail.com', 'pass', '9-NOV-1970', null);
INSERT INTO PROFILE values('abh90', 'Carita', 'abh90@gmail.com', 'pass', '10-MAY-2003', null);
INSERT INTO PROFILE values('hye5', 'Cathryn', 'hye5@gmail.com', 'pass', '16-OCT-1983', null);
INSERT INTO PROFILE values('esi7', 'Edmond', 'esi7@gmail.com', 'pass', '1-FEB-1983', null);
INSERT INTO PROFILE values('taj52', 'Micaela', 'taj52@gmail.com', 'pass', '5-JUL-1971', null);
INSERT INTO PROFILE values('cbm65', 'Lewis', 'cbm65@gmail.com', 'pass', '28-JUN-1992', null);
INSERT INTO PROFILE values('imw75', 'Evon', 'imw75@gmail.com', 'pass', '9-OCT-1996', null);
INSERT INTO PROFILE values('hkk63', 'Verena', 'hkk63@gmail.com', 'pass', '20-APR-1957', null);
INSERT INTO PROFILE values('ujo14', 'Emmitt', 'ujo14@gmail.com', 'pass', '2-SEP-1993', null);
INSERT INTO PROFILE values('tmg82', 'Lorette', 'tmg82@gmail.com', 'pass', '25-NOV-1973', null);
INSERT INTO PROFILE values('vlx50', 'Charis', 'vlx50@gmail.com', 'pass', '4-FEB-1961', null);
INSERT INTO PROFILE values('oly50', 'Clint', 'oly50@gmail.com', 'pass', '10-FEB-2000', null);
INSERT INTO PROFILE values('psf22', 'Clelia', 'psf22@gmail.com', 'pass', '19-FEB-1986', null);
INSERT INTO PROFILE values('rzq34', 'Ralph', 'rzq34@gmail.com', 'pass', '9-DEC-1970', null);
INSERT INTO PROFILE values('spq86', 'Jaleesa', 'spq86@gmail.com', 'pass', '11-NOV-1959', null);
INSERT INTO PROFILE values('gjz90', 'Shanna', 'gjz90@gmail.com', 'pass', '23-NOV-1971', null);
INSERT INTO PROFILE values('any88', 'Alaina', 'any88@gmail.com', 'pass', '28-DEC-1973', null);
INSERT INTO PROFILE values('zsy35', 'Ranae', 'zsy35@gmail.com', 'pass', '6-DEC-1993', null);
INSERT INTO PROFILE values('png51', 'Lan', 'png51@gmail.com', 'pass', '9-JUL-1997', null);
INSERT INTO PROFILE values('uly89', 'Nida', 'uly89@gmail.com', 'pass', '1-AUG-1952', null);
INSERT INTO PROFILE values('who78', 'Estela', 'who78@gmail.com', 'pass', '25-MAY-1969', null);
INSERT INTO PROFILE values('wux53', 'Shantae', 'wux53@gmail.com', 'pass', '23-OCT-1992', null);
INSERT INTO PROFILE values('kpp59', 'Merlene', 'kpp59@gmail.com', 'pass', '18-JAN-1992', null);
INSERT INTO PROFILE values('cki84', 'Arthur', 'cki84@gmail.com', 'pass', '21-JAN-1960', null);
INSERT INTO PROFILE values('ccp6', 'Efrain', 'ccp6@gmail.com', 'pass', '5-NOV-1973', null);
INSERT INTO PROFILE values('qnz10', 'Tenisha', 'qnz10@gmail.com', 'pass', '28-FEB-1998', null);
INSERT INTO PROFILE values('vtv25', 'Micah', 'vtv25@gmail.com', 'pass', '7-APR-1951', null);
INSERT INTO PROFILE values('xfi24', 'Winter', 'xfi24@gmail.com', 'pass', '16-APR-1965', null);
INSERT INTO PROFILE values('ewt76', 'Carolin', 'ewt76@gmail.com', 'pass', '9-JAN-1958', null);
INSERT INTO PROFILE values('mvd44', 'Taina', 'mvd44@gmail.com', 'pass', '13-MAY-1958', null);
INSERT INTO PROFILE values('lzx70', 'Dianne', 'lzx70@gmail.com', 'pass', '21-JAN-1981', null);
INSERT INTO PROFILE values('hcq44', 'Bette', 'hcq44@gmail.com', 'pass', '1-OCT-1956', null);
INSERT INTO PROFILE values('vbt41', 'Joel', 'vbt41@gmail.com', 'pass', '15-MAY-1966', null);
INSERT INTO PROFILE values('uzu70', 'Rey', 'uzu70@gmail.com', 'pass', '3-JUL-1988', null);
INSERT INTO PROFILE values('gyi100', 'Jeffrey', 'gyi100@gmail.com', 'pass', '10-JUL-1978', null);
INSERT INTO PROFILE values('jfm52', 'Sergio', 'jfm52@gmail.com', 'pass', '23-MAR-2001', null);
INSERT INTO PROFILE values('wde93', 'Josiah', 'wde93@gmail.com', 'pass', '4-DEC-1990', null);
INSERT INTO PROFILE values('tmx27', 'Madonna', 'tmx27@gmail.com', 'pass', '15-FEB-1999', null);
INSERT INTO PROFILE values('glz95', 'Dusti', 'glz95@gmail.com', 'pass', '19-AUG-1992', null);
INSERT INTO PROFILE values('ujg95', 'Lynne', 'ujg95@gmail.com', 'pass', '28-SEP-1961', null);
INSERT INTO PROFILE values('guf94', 'Ariel', 'guf94@gmail.com', 'pass', '25-OCT-1997', null);
INSERT INTO PROFILE values('gjc33', 'Wanetta', 'gjc33@gmail.com', 'pass', '25-FEB-2000', null);
INSERT INTO PROFILE values('mvv9', 'Renaldo', 'mvv9@gmail.com', 'pass', '5-SEP-1960', null);
INSERT INTO PROFILE values('fpz13', 'May', 'fpz13@gmail.com', 'pass', '23-JAN-1980', null);
INSERT INTO PROFILE values('guo28', 'Ramon', 'guo28@gmail.com', 'pass', '26-OCT-1966', null);
INSERT INTO PROFILE values('wsb72', 'Mariann', 'wsb72@gmail.com', 'pass', '7-MAR-1964', null);
INSERT INTO PROFILE values('gcr30', 'Tessa', 'gcr30@gmail.com', 'pass', '11-SEP-1955', null);
INSERT INTO PROFILE values('cfn18', 'Belinda', 'cfn18@gmail.com', 'pass', '16-MAR-1997', null);
INSERT INTO PROFILE values('ufq86', 'Johna', 'ufq86@gmail.com', 'pass', '23-SEP-1984', null);
INSERT INTO PROFILE values('bjk39', 'Jerrie', 'bjk39@gmail.com', 'pass', '27-APR-1994', null);
INSERT INTO PROFILE values('goa89', 'Felicidad', 'goa89@gmail.com', 'pass', '16-NOV-1951', null);
INSERT INTO PROFILE values('mbk60', 'Frida', 'mbk60@gmail.com', 'pass', '14-APR-1961', null);
INSERT INTO PROFILE values('qjr89', 'Samuel', 'qjr89@gmail.com', 'pass', '23-FEB-1962', null);
INSERT INTO PROFILE values('fyb65', 'Dominga', 'fyb65@gmail.com', 'pass', '12-FEB-1976', null);
INSERT INTO PROFILE values('aqq42', 'Maryjane', 'aqq42@gmail.com', 'pass', '4-JAN-1961', null);
INSERT INTO PROFILE values('jqa59', 'Constance', 'jqa59@gmail.com', 'pass', '17-FEB-1971', null);
INSERT INTO PROFILE values('eyi68', 'Georgann', 'eyi68@gmail.com', 'pass', '22-MAR-1981', null);
INSERT INTO PROFILE values('xwg21', 'Meta', 'xwg21@gmail.com', 'pass', '23-NOV-1961', null);
INSERT INTO PROFILE values('irq78', 'Angelyn', 'irq78@gmail.com', 'pass', '22-AUG-1964', null);
INSERT INTO PROFILE values('nig24', 'Keith', 'nig24@gmail.com', 'pass', '11-NOV-1984', null);
INSERT INTO PROFILE values('utk40', 'Prudence', 'utk40@gmail.com', 'pass', '14-NOV-1971', null);
INSERT INTO PROFILE values('des7', 'Debera', 'des7@gmail.com', 'pass', '2-SEP-1951', null);
INSERT INTO PROFILE values('qmk58', 'Maxine', 'qmk58@gmail.com', 'pass', '21-JUL-1990', null);
INSERT INTO PROFILE values('lko38', 'Kenny', 'lko38@gmail.com', 'pass', '25-FEB-1960', null);
INSERT INTO PROFILE values('msf68', 'Barbera', 'msf68@gmail.com', 'pass', '26-JUN-1955', null);
INSERT INTO PROFILE values('lac65', 'Richelle', 'lac65@gmail.com', 'pass', '1-JUN-1992', null);
INSERT INTO PROFILE values('ghm1', 'Ana', 'ghm1@gmail.com', 'pass', '21-MAR-1994', null);
INSERT INTO PROFILE values('hed31', 'Esta', 'hed31@gmail.com', 'pass', '6-AUG-1958', null);
INSERT INTO PROFILE values('ypw38', 'Jeannie', 'ypw38@gmail.com', 'pass', '20-MAR-1970', null);
INSERT INTO PROFILE values('trn95', 'Sheron', 'trn95@gmail.com', 'pass', '1-MAY-1955', null);
INSERT INTO PROFILE values('iah90', 'Berniece', 'iah90@gmail.com', 'pass', '21-FEB-1991', null);
INSERT INTO PROFILE values('mdz20', 'Lloyd', 'mdz20@gmail.com', 'pass', '1-APR-1985', null);
INSERT INTO PROFILE values('pcj11', 'Myles', 'pcj11@gmail.com', 'pass', '17-MAY-1965', null);
INSERT INTO PROFILE values('bwf75', 'April', 'bwf75@gmail.com', 'pass', '16-AUG-1976', null);
INSERT INTO PROFILE values('mes68', 'Enedina', 'mes68@gmail.com', 'pass', '20-NOV-1965', null);
INSERT INTO PROFILE values('gpv58', 'Francesco', 'gpv58@gmail.com', 'pass', '27-JAN-1957', null);
INSERT INTO PROFILE values('nnp98', 'Lucinda', 'nnp98@gmail.com', 'pass', '7-MAR-1993', null);
INSERT INTO PROFILE values('nrk95', 'Vince', 'nrk95@gmail.com', 'pass', '8-MAY-2003', null);
INSERT INTO PROFILE values('eaa11', 'Hermine', 'eaa11@gmail.com', 'pass', '23-MAR-1998', null);
INSERT INTO PROFILE values('pqg2', 'Vince', 'pqg2@gmail.com', 'pass', '10-JUN-1962', null);
INSERT INTO PROFILE values('obr28', 'Adriene', 'obr28@gmail.com', 'pass', '16-NOV-1953', null);
INSERT INTO PROFILE values('pqr1', 'Alex', 'pqr1@gmail.com', 'pass', '20-AUG-1987', null);
INSERT INTO PROFILE values('jzv44', 'Rodolfo', 'jzv44@gmail.com', 'pass', '14-DEC-1958', null);
INSERT INTO PROFILE values('noc45', 'Katheleen', 'noc45@gmail.com', 'pass', '4-SEP-1967', null);
INSERT INTO PROFILE values('upg89', 'Makeda', 'upg89@gmail.com', 'pass', '18-SEP-1952', null);
INSERT INTO PROFILE values('jnx15', 'Kiyoko', 'jnx15@gmail.com', 'pass', '25-SEP-1961', null);
INSERT INTO PROFILE values('cwm65', 'Reita', 'cwm65@gmail.com', 'pass', '5-JUL-1988', null);
INSERT INTO PROFILE values('lnp65', 'Hollis', 'lnp65@gmail.com', 'pass', '4-APR-1972', null);
INSERT INTO PROFILE values('cxo76', 'Graig', 'cxo76@gmail.com', 'pass', '7-JUL-2001', null);
INSERT INTO PROFILE values('mrk30', 'Bettye', 'mrk30@gmail.com', 'pass', '11-SEP-1973', null);
INSERT INTO PROFILE values('vgs8', 'Kimiko', 'vgs8@gmail.com', 'pass', '3-DEC-1985', null);
INSERT INTO PROFILE values('kti55', 'Frances', 'kti55@gmail.com', 'pass', '8-MAY-1998', null);
INSERT INTO PROFILE values('zet73', 'Heike', 'zet73@gmail.com', 'pass', '16-NOV-1993', null);

---GENERATE USER FRIENDSHIPS
INSERT INTO FRIENDS values('lko38', 'lac65', '16-MAR-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vlx50', 'spq86', '7-DEC-1998', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ypw38', 'gpv58', '8-AUG-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cxo76', 'abh90', '19-JUN-1987', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('kpp59', 'qmk58', '18-SEP-1996', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('pqr1', 'guf94', '21-MAY-1965', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('zet73', 'pqg2', '4-APR-1980', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('goa89', 'ghm1', '13-JUL-1960', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vlx50', 'gyi100', '13-NOV-2004', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lac65', 'hru38', '11-MAY-1956', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jnx15', 'gjz90', '24-FEB-1963', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('zet73', 'lac65', '20-MAY-1984', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hkk63', 'who78', '10-MAR-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('rzq34', 'aqq42', '6-MAY-1980', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('stb41', 'gyi100', '28-NOV-1950', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('uly89', 'hru38', '8-NOV-1961', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ypw38', 'vbt41', '23-JUN-1967', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lko38', 'gjc33', '19-APR-1994', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lko38', 'cki84', '22-OCT-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('eaa11', 'hye5', '7-FEB-1954', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('qmk58', 'bwf75', '6-AUG-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cbm65', 'lnp65', '20-AUG-1971', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('rzq34', 'bwf75', '9-MAR-1967', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('kti55', 'goa89', '26-APR-1952', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('obr28', 'lnp65', '22-DEC-1992', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('eyi68', 'atz36', '18-DEC-1987', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vbt41', 'hkk63', '25-SEP-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('who78', 'ssc60', '6-JUL-1952', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('who78', 'rzq34', '28-AUG-1960', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('xwg21', 'jfm52', '25-MAY-1994', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ujo14', 'ewt76', '2-DEC-1969', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('uly89', 'tmx27', '19-JUN-1988', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('aqq42', 'qjr89', '26-JUL-1998', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hkk63', 'cfn18', '6-SEP-1962', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('png51', 'esi7', '9-JUL-1970', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('msf68', 'mdz20', '3-MAR-1965', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vtv25', 'bhf42', '20-APR-1993', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('qnz10', 'des7', '9-APR-1961', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('glz95', 'mvv9', '3-FEB-1961', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('bif47', 'qjr89', '9-MAR-1957', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jfm52', 'upg89', '20-FEB-1978', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('imw75', 'hcq44', '24-MAR-1961', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('oly50', 'jqa59', '21-MAY-1998', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('imw75', 'bhf42', '26-AUG-2000', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('any88', 'ypw38', '16-NOV-1992', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gyi100', 'nrk95', '11-SEP-1958', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('eyi68', 'qjr89', '1-FEB-2001', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('kpp59', 'nrk95', '21-DEC-1979', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('trn95', 'gyi100', '14-JUL-2003', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('oly50', 'cwm65', '10-JUL-1970', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jzv44', 'bif47', '22-OCT-1954', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cwm65', 'psf22', '7-FEB-1993', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('esi7', 'ypw38', '10-AUG-1980', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('nrk95', 'zsy35', '20-APR-2001', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('spq86', 'mbk60', '1-JUN-1987', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cfn18', 'wde93', '4-OCT-1989', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('pqr1', 'hjh84', '19-MAY-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('msf68', 'qnz10', '16-DEC-1971', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cki84', 'gcr30', '18-JAN-1994', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cfn18', 'trn95', '17-DEC-1974', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mbk60', 'msf68', '21-APR-1953', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('esi7', 'ccp6', '3-AUG-1974', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jqa59', 'bif47', '5-NOV-2001', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('png51', 'eyi68', '14-JUL-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('nrk95', 'vbt41', '1-SEP-2003', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ewt76', 'wsb72', '16-OCT-1985', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vlx50', 'ypw38', '21-JAN-1964', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mrk30', 'lko38', '11-OCT-1999', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('pqg2', 'who78', '3-MAY-1972', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('uly89', 'lac65', '5-MAR-1956', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ujo14', 'fyb65', '8-JAN-1993', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cxo76', 'xfi24', '13-JUL-1952', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('wsb72', 'xwg21', '23-JUN-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('eyi68', 'gjc33', '23-OCT-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hwp59', 'hed31', '17-JUL-1974', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ufq86', 'ssc60', '5-APR-1962', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('xwg21', 'utk40', '18-APR-1989', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('uly89', 'cfn18', '11-FEB-2004', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('noc45', 'trn95', '9-SEP-1955', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lac65', 'jqa59', '16-MAR-1954', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('any88', 'cfn18', '15-MAR-1956', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('esi7', 'fpz13', '10-JAN-1963', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvv9', 'ujg95', '17-AUG-1985', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jqa59', 'vtv25', '8-AUG-1952', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vlx50', 'lnp65', '24-NOV-2002', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvv9', 'ujo14', '11-NOV-1962', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gjc33', 'utk40', '13-JUL-1955', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvv9', 'des7', '21-AUG-1979', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('xwg21', 'rzq34', '11-SEP-1970', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ujo14', 'irq78', '16-JUN-1958', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lko38', 'nrk95', '13-FEB-2003', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hcq44', 'cwm65', '13-JUN-1955', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('stb41', 'oly50', '8-SEP-1964', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hcq44', 'fyb65', '23-MAY-1955', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('oly50', 'irq78', '10-SEP-1991', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('kti55', 'mbk60', '26-APR-1974', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('psf22', 'oly50', '23-SEP-2000', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('nig24', 'tmx27', '26-AUG-1966', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('rzq34', 'ujo14', '15-SEP-1975', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('goa89', 'gyi100', '7-FEB-1958', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gpv58', 'bjk39', '9-FEB-2003', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('nrk95', 'atz36', '2-APR-1988', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvv9', 'atz36', '11-MAY-1988', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hed31', 'pqg2', '10-MAY-1970', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('imw75', 'vgs8', '25-OCT-1955', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gcr30', 'hjh84', '2-FEB-1957', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('fyb65', 'imw75', '23-MAY-1952', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('goa89', 'any88', '14-MAR-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('qjr89', 'jzv44', '11-FEB-1979', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hye5', 'atz36', '7-NOV-1989', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('wux53', 'cxo76', '20-FEB-1956', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('guf94', 'goa89', '28-APR-1978', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cbm65', 'aqq42', '9-MAY-1955', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('abh90', 'zet73', '23-SEP-1988', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('zet73', 'ufq86', '27-JUN-1951', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('fpz13', 'hjh84', '7-SEP-1969', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('psf22', 'msf68', '19-JUL-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('uly89', 'nig24', '11-AUG-1973', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('tmx27', 'ssc60', '3-MAR-1951', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('tmg82', 'any88', '18-SEP-2004', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vlx50', 'stb41', '1-AUG-1996', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('wsb72', 'tmg82', '20-JUL-1952', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hru38', 'ccp6', '2-MAR-1995', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('pqr1', 'atz36', '9-JUN-1998', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('jqa59', 'ghm1', '2-MAR-1996', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('msf68', 'lko38', '1-MAR-1975', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvd44', 'mdz20', '16-MAR-1973', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ujo14', 'fpz13', '4-MAR-1964', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('imw75', 'qjr89', '28-OCT-1970', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vtv25', 'bif47', '14-MAR-1983', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('guf94', 'wde93', '18-JUL-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jzv44', 'trn95', '2-NOV-1959', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jfm52', 'ssc60', '13-JUN-1997', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('trn95', 'cwm65', '2-AUG-1985', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('imw75', 'esi7', '13-JUN-1980', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jnx15', 'nnp98', '5-MAY-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ssc60', 'vgs8', '21-OCT-2004', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('vtv25', 'who78', '11-JUN-1957', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jnx15', 'hjh84', '11-NOV-1975', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('pqr1', 'lnp65', '21-OCT-1978', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('zsy35', 'nnp98', '28-MAY-1999', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gjz90', 'hed31', '9-MAY-1987', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gjz90', 'lko38', '18-JUN-1970', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('qnz10', 'eyi68', '23-MAR-1951', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('eyi68', 'qmk58', '20-MAR-1978', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('qmk58', 'zet73', '22-JUL-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('taj52', 'gcr30', '2-JUN-1953', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('aqq42', 'hed31', '18-NOV-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cki84', 'wsb72', '4-JUN-1993', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mrk30', 'png51', '28-DEC-1964', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvd44', 'eyi68', '1-JUN-1961', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('who78', 'psf22', '22-APR-1979', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hkk63', 'zet73', '2-JUN-1976', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('atz36', 'jzv44', '13-MAR-1989', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gyi100', 'jnx15', '12-JUN-1983', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('psf22', 'hed31', '22-SEP-1995', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('zsy35', 'jzv44', '22-OCT-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ujg95', 'stb41', '28-AUG-1998', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mdz20', 'nig24', '8-OCT-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('glz95', 'psf22', '7-NOV-1993', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hed31', 'xfi24', '21-APR-1993', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('xfi24', 'who78', '7-MAY-1998', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('nrk95', 'cwm65', '22-JUN-1991', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('mvd44', 'nrk95', '13-DEC-1972', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gpv58', 'wde93', '25-JUN-1960', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cwm65', 'zet73', '3-MAY-1978', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('zsy35', 'kti55', '13-MAR-1967', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lac65', 'qjr89', '27-MAR-1960', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jzv44', 'abh90', '22-MAY-1994', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('goa89', 'vtv25', '7-FEB-1978', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('gpv58', 'gjc33', '20-JUL-1987', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('abh90', 'nig24', '12-SEP-2003', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('xfi24', 'zsy35', '25-JAN-1998', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('pqg2', 'vgs8', '20-NOV-1950', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('qmk58', 'abh90', '10-JUN-1957', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('noc45', 'xwg21', '17-FEB-1972', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('fyb65', 'pqg2', '8-DEC-1999', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('lac65', 'qnz10', '20-MAY-1970', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('xfi24', 'nrk95', '24-APR-1990', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('jnx15', 'imw75', '18-MAR-1997', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('kti55', 'rzq34', '4-MAY-1976', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('oly50', 'obr28', '11-JUN-1969', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('qnz10', 'glz95', '15-NOV-1989', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('uzu70', 'stb41', '7-FEB-1995', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('guf94', 'cbm65', '18-JUL-1961', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ufq86', 'vlx50', '11-MAY-1990', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('guo28', 'spq86', '20-MAY-1981', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('ghm1', 'bif47', '24-NOV-1980', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('fyb65', 'hjh84', '7-JUL-1974', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('xwg21', 'xfi24', '2-MAR-1968', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('taj52', 'zet73', '1-JUL-1973', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cki84', 'taj52', '25-JAN-1997', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('cbm65', 'gpv58', '22-APR-1986', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('lac65', 'des7', '9-MAY-1976', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('mbk60', 'pqg2', '15-SEP-1966', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hkk63', 'ghm1', '24-JAN-1966', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hye5', 'oly50', '1-NOV-1951', 'Hi, would you liketo be my friend?');
INSERT INTO FRIENDS values('mrk30', 'jqa59', '7-OCT-2002', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('guf94', 'msf68', '13-JUL-1982', 'Hi, would you like to be my friend?');
INSERT INTO FRIENDS values('hjh84', 'cfn18', '2-FEB-1981', 'Hi, would you like to be my friend?');

--GENERATE GROUPS
INSERT INTO GROUPS values(1, 'Computer Science', 'A group for all of the Computer Science majors to discuss classes and ask for help.');
INSERT INTO GROUPS values(2, 'Pitt College DEMS', 'A group for democrats at pitt to share and discuss articles');
INSERT INTO GROUPS values(3, 'Pitt Gaming Club', 'Hey, welcome to the Pitt Gaming Club! We play all of video and tabletop games.');
INSERT INTO GROUPS values(4, 'Stock Trading Pitt', 'The Stock Trading Pitt is a student organization that focuses on what it takes to trade in today''s markets');
INSERT INTO GROUPS values(5, 'Pitt Animal Lover''s Club', 'Pitt Animal Lovers'' Club is a service organization dedicated to incorporating Pitt Students'' love of animals to campus life.');
INSERT INTO GROUPS values(6, 'Pitt Panthers Fanatics', 'A Facebook forum to discuss Pitt football, Pitt basketball and all things Pitt.');
INSERT INTO GROUPS values(7, 'Enactus Pitt', 'Seeking possibilites, taking action, enabling progress.');
INSERT INTO GROUPS values(8, 'Pitt SCNO', 'Group for people working on current projects');
INSERT INTO GROUPS values(9, 'Pitt GB', 'Global Brigades at the University of Pittsburgh is dedicated to tackling issues related to sustainability and community development in the international world.');
INSERT INTO GROUPS values(10, 'Pitt Transfer Student Association', 'Pitt student organization for new and returning transfer students');

--GENERATE MESSAGES
INSERT INTO MESSAGES values('1', 'nig24', 'Is CS1555 a hard class?', 'ghm1', null, '17-DEC-2011');
INSERT INTO MESSAGERECIPIENT values('1', 'ghm1');
INSERT INTO MESSAGES values('2', 'gpv58', 'What do you think of Trump?', 'qjr89', null, '4-MAY-2008');
INSERT INTO MESSAGERECIPIENT values('2', 'qjr89');
INSERT INTO MESSAGES values('3', 'png51', 'What''s the point of this message?', 'glz95', null, '18-JAN-2015');
INSERT INTO MESSAGERECIPIENT values('3', 'glz95');
INSERT INTO MESSAGES values('4', 'gjc33', 'Are there any good groups to join?', 'glz95', null, '8-JUN-2005');
INSERT INTO MESSAGERECIPIENT values('4', 'glz95');
INSERT INTO MESSAGES values('5', 'eaa11', 'Hi, how are you doing?', 'utk40', null, '25-JUL-2016');
INSERT INTO MESSAGERECIPIENT values('5', 'utk40');
INSERT INTO MESSAGES values('6', 'bjk39', 'What''s the point of this message?', 'bhf42', null, '23-SEP-2016');
INSERT INTO MESSAGERECIPIENT values('6', 'bhf42');
INSERT INTO MESSAGES values('7', 'jqa59', 'What do you think of Panos as a professor?', 'kti55', null, '16-JUN-2007');
INSERT INTO MESSAGERECIPIENT values('7', 'kti55');
INSERT INTO MESSAGES values('8', 'mes68', 'I''m just sending this to fill the database', 'spq86', null, '14-AUG-2013');
INSERT INTO MESSAGERECIPIENT values('8', 'spq86');
INSERT INTO MESSAGES values('9', 'wde93', 'Are there any good groups to join?', 'gjz90', null, '13-APR-2005');
INSERT INTO MESSAGERECIPIENT values('9', 'gjz90');
INSERT INTO MESSAGES values('10', 'pqr1', 'What''s the point of this message?', 'jfm52', null, '5-OCT-2009');
INSERT INTO MESSAGERECIPIENT values('10', 'jfm52');
INSERT INTO MESSAGES values('11', 'mvd44', 'Are there any good groups to join?', 'vtv25', null, '13-JUN-2016');
INSERT INTO MESSAGERECIPIENT values('11', 'vtv25');
INSERT INTO MESSAGES values('12', 'mvv9', 'What do you think of Panos as a professor?', 'eaa11', null, '11-AUG-2010');
INSERT INTO MESSAGERECIPIENT values('12', 'eaa11');
INSERT INTO MESSAGES values('13', 'hwp59', 'Hey, whats up?', 'ssc60', null, '22-JAN-2011');
INSERT INTO MESSAGERECIPIENT values('13', 'ssc60');
INSERT INTO MESSAGES values('14', 'zet73', 'Are there any good groups to join?', 'taj52', null, '24-JUN-2005');
INSERT INTO MESSAGERECIPIENT values('14', 'taj52');
INSERT INTO MESSAGES values('15', 'guo28', 'Hi, how are you doing?', 'ypw38', null, '1-JAN-2016');
INSERT INTO MESSAGERECIPIENT values('15', 'ypw38');
INSERT INTO MESSAGES values('16', 'hru38', 'Hey, whats up?', 'wux53', null, '23-MAR-2010');
INSERT INTO MESSAGERECIPIENT values('16', 'wux53');
INSERT INTO MESSAGES values('17', 'wsb72', 'Are there any good groups to join?', 'imw75', null, '1-AUG-2011');
INSERT INTO MESSAGERECIPIENT values('17', 'imw75');
INSERT INTO MESSAGES values('18', 'lko38', 'Hi, how are you doing?', 'gjc33', null, '8-MAY-2011');
INSERT INTO MESSAGERECIPIENT values('18', 'gjc33');
INSERT INTO MESSAGES values('19', 'cki84', 'Are there any good groups to join?', 'ccp6', null, '13-FEB-2016');
INSERT INTO MESSAGERECIPIENT values('19', 'ccp6');
INSERT INTO MESSAGES values('20', 'glz95', 'Hey, whats up?', 'aqq42', null, '13-JUL-2009');
INSERT INTO MESSAGERECIPIENT values('20', 'aqq42');
INSERT INTO MESSAGES values('21', 'who78', 'Are there any good groups to join?', 'gyi100', null, '17-JUN-2005');
INSERT INTO MESSAGERECIPIENT values('21', 'gyi100');
INSERT INTO MESSAGES values('22', 'goa89', 'This message was generated in order to fill up the message table', 'lac65', null, '8-DEC-2015');
INSERT INTO MESSAGERECIPIENT values('22', 'lac65');
INSERT INTO MESSAGES values('23', 'zet73', 'What''s the point of this message?', 'cki84', null, '11-JUN-2007');
INSERT INTO MESSAGERECIPIENT values('23', 'cki84');
INSERT INTO MESSAGES values('24', 'xwg21', 'Hi, how are you doing?', 'imw75', null, '26-AUG-2011');
INSERT INTO MESSAGERECIPIENT values('24', 'imw75');
INSERT INTO MESSAGES values('25', 'pcj11', 'Hey, whats up?', 'wde93', null, '12-FEB-2012');
INSERT INTO MESSAGERECIPIENT values('25', 'wde93');
INSERT INTO MESSAGES values('26', 'atz36', 'What''s the point of this message?', 'ghm1', null, '14-AUG-2007');
INSERT INTO MESSAGERECIPIENT values('26', 'ghm1');
INSERT INTO MESSAGES values('27', 'mvv9', 'This message was generated in order to fill up the message table', 'mdz20', null, '28-APR-2014');
INSERT INTO MESSAGERECIPIENT values('27', 'mdz20');
INSERT INTO MESSAGES values('28', 'stb41', 'I''m just sending this to fill the database', 'mdz20', null, '12-NOV-2010');
INSERT INTO MESSAGERECIPIENT values('28', 'mdz20');
INSERT INTO MESSAGES values('29', 'mvd44', 'What''s the point of this message?', 'vbt41', null, '18-NOV-2006');
INSERT INTO MESSAGERECIPIENT values('29', 'vbt41');
INSERT INTO MESSAGES values('30', 'mbk60', 'Hi, how are you doing?', 'aqq42', null, '15-JUN-2015');
INSERT INTO MESSAGERECIPIENT values('30', 'aqq42');
INSERT INTO MESSAGES values('31', 'noc45', 'This message was generated in order to fill up the message table', 'lac65', null, '24-APR-2013');
INSERT INTO MESSAGERECIPIENT values('31', 'lac65');
INSERT INTO MESSAGES values('32', 'vbt41', 'This message was generated in order to fill up the message table', 'jnx15', null, '4-JUN-2015');
INSERT INTO MESSAGERECIPIENT values('32', 'jnx15');
INSERT INTO MESSAGES values('33', 'who78', 'This message was generated in order to fill up the message table', 'pqg2', null, '13-FEB-2006');
INSERT INTO MESSAGERECIPIENT values('33', 'pqg2');
INSERT INTO MESSAGES values('34', 'cbm65', 'What''s the point of this message?', 'glz95', null, '9-MAR-2012');
INSERT INTO MESSAGERECIPIENT values('34', 'glz95');
INSERT INTO MESSAGES values('35', 'pqr1', 'Hi, how are you doing?', 'mes68', null, '23-JUL-2015');
INSERT INTO MESSAGERECIPIENT values('35', 'mes68');
INSERT INTO MESSAGES values('36', 'atz36', 'What do you think of Trump?', 'jfm52', null, '11-APR-2011');
INSERT INTO MESSAGERECIPIENT values('36', 'jfm52');
INSERT INTO MESSAGES values('37', 'gjc33', 'What do you think of Panos as a professor?', 'cwm65', null, '16-FEB-2012');
INSERT INTO MESSAGERECIPIENT values('37', 'cwm65');
INSERT INTO MESSAGES values('38', 'vtv25', 'Hey, whats up?', 'cwm65', null, '7-OCT-2012');
INSERT INTO MESSAGERECIPIENT values('38', 'cwm65');
INSERT INTO MESSAGES values('39', 'gjz90', 'This message was generated in order to fill up the message table', 'psf22', null, '14-JUN-2011');
INSERT INTO MESSAGERECIPIENT values('39', 'psf22');
INSERT INTO MESSAGES values('40', 'des7', 'What do you think of Trump?', 'mdz20', null, '27-FEB-2010');
INSERT INTO MESSAGERECIPIENT values('40', 'mdz20');
INSERT INTO MESSAGES values('41', 'jqa59', 'What do you think of Panos as a professor?', 'taj52', null, '13-AUG-2012');
INSERT INTO MESSAGERECIPIENT values('41', 'taj52');
INSERT INTO MESSAGES values('42', 'des7', 'What do you think of Trump?', 'upg89', null, '22-APR-2011');
INSERT INTO MESSAGERECIPIENT values('42', 'upg89');
INSERT INTO MESSAGES values('43', 'zsy35', 'What do you think of Panos as a professor?', 'jfm52', null, '5-MAY-2007');
INSERT INTO MESSAGERECIPIENT values('43', 'jfm52');
INSERT INTO MESSAGES values('44', 'vtv25', 'Hey, whats up?', 'png51', null, '25-MAR-2007');
INSERT INTO MESSAGERECIPIENT values('44', 'png51');
INSERT INTO MESSAGES values('45', 'kti55', 'Hey, whats up?', 'qnz10', null, '13-DEC-2016');
INSERT INTO MESSAGERECIPIENT values('45', 'qnz10');
INSERT INTO MESSAGES values('46', 'bhf42', 'What do you think of Trump?', 'wsb72', null, '25-JUL-2015');
INSERT INTO MESSAGERECIPIENT values('46', 'wsb72');
INSERT INTO MESSAGES values('47', 'qnz10', 'Are there any good groups to join?', 'lko38', null, '11-MAY-2014');
INSERT INTO MESSAGERECIPIENT values('47', 'lko38');
INSERT INTO MESSAGES values('48', 'gjc33', 'Hey, whats up?', 'spq86', null, '25-MAY-2014');
INSERT INTO MESSAGERECIPIENT values('48', 'spq86');
INSERT INTO MESSAGES values('49', 'kti55', 'Hey, whats up?', 'png51', null, '22-JUL-2009');
INSERT INTO MESSAGERECIPIENT values('49', 'png51');
INSERT INTO MESSAGES values('50', 'pcj11', 'What do you think of Panos as a professor?', 'eyi68', null, '22-AUG-2015');
INSERT INTO MESSAGERECIPIENT values('50', 'eyi68');
INSERT INTO MESSAGES values('51', 'imw75', 'I''m just sending this to fill the database', 'guo28', null, '19-FEB-2016');
INSERT INTO MESSAGERECIPIENT values('51', 'guo28');
INSERT INTO MESSAGES values('52', 'upg89', 'Is CS1555 a hard class?', 'cxo76', null, '4-SEP-2008');
INSERT INTO MESSAGERECIPIENT values('52', 'cxo76');
INSERT INTO MESSAGES values('53', 'aqq42', 'Are there any good groups to join?', 'wsb72', null, '15-FEB-2005');
INSERT INTO MESSAGERECIPIENT values('53', 'wsb72');
INSERT INTO MESSAGES values('54', 'fyb65', 'What''s the point of this message?', 'png51', null, '28-JAN-2012');
INSERT INTO MESSAGERECIPIENT values('54', 'png51');
INSERT INTO MESSAGES values('55', 'hkk63', 'Hi, how are you doing?', 'hed31', null, '25-OCT-2008');
INSERT INTO MESSAGERECIPIENT values('55', 'hed31');
INSERT INTO MESSAGES values('56', 'des7', 'What''s the point of this message?', 'pqr1', null, '4-SEP-2005');
INSERT INTO MESSAGERECIPIENT values('56', 'pqr1');
INSERT INTO MESSAGES values('57', 'who78', 'I''m just sending this to fill the database', 'vgs8', null, '27-SEP-2007');
INSERT INTO MESSAGERECIPIENT values('57', 'vgs8');
INSERT INTO MESSAGES values('58', 'uzu70', 'This message was generated in order to fill up the message table', 'wsb72', null, '9-JAN-2007');
INSERT INTO MESSAGERECIPIENT values('58', 'wsb72');
INSERT INTO MESSAGES values('59', 'wux53', 'This message was generated in order to fill up the message table', 'noc45', null, '22-APR-2015');
INSERT INTO MESSAGERECIPIENT values('59', 'noc45');
INSERT INTO MESSAGES values('60', 'ujo14', 'Hi, how are you doing?', 'cbm65', null, '24-MAR-2005');
INSERT INTO MESSAGERECIPIENT values('60', 'cbm65');
INSERT INTO MESSAGES values('61', 'jzv44', 'What do you think of Trump?', 'jnx15', null, '8-AUG-2008');
INSERT INTO MESSAGERECIPIENT values('61', 'jnx15');
INSERT INTO MESSAGES values('62', 'ujo14', 'Are there any good groups to join?', 'ccp6', null, '23-JAN-2015');
INSERT INTO MESSAGERECIPIENT values('62', 'ccp6');
INSERT INTO MESSAGES values('63', 'wux53', 'What''s the point of this message?', 'hye5', null, '24-JUL-2016');
INSERT INTO MESSAGERECIPIENT values('63', 'hye5');
INSERT INTO MESSAGES values('64', 'who78', 'What''s the point of this message?', 'des7', null, '12-AUG-2016');
INSERT INTO MESSAGERECIPIENT values('64', 'des7');
INSERT INTO MESSAGES values('65', 'vlx50', 'Hey, whats up?', 'cki84', null, '23-JUL-2013');
INSERT INTO MESSAGERECIPIENT values('65', 'cki84');
INSERT INTO MESSAGES values('66', 'jnx15', 'Are there any good groups to join?', 'hkk63', null, '20-JUN-2012');
INSERT INTO MESSAGERECIPIENT values('66', 'hkk63');
INSERT INTO MESSAGES values('67', 'hwp59', 'Hi, how are you doing?', 'ypw38', null, '25-NOV-2005');
INSERT INTO MESSAGERECIPIENT values('67', 'ypw38');
INSERT INTO MESSAGES values('68', 'eaa11', 'What do you think of Panos as a professor?', 'qmk58', null, '18-OCT-2010');
INSERT INTO MESSAGERECIPIENT values('68', 'qmk58');
INSERT INTO MESSAGES values('69', 'jqa59', 'Are there any good groups to join?', 'hcq44', null, '1-MAR-2015');
INSERT INTO MESSAGERECIPIENT values('69', 'hcq44');
INSERT INTO MESSAGES values('70', 'uzu70', 'This message was generated in order to fill up the message table', 'jfm52', null, '22-SEP-2012');
INSERT INTO MESSAGERECIPIENT values('70', 'jfm52');
INSERT INTO MESSAGES values('71', 'jzv44', 'Hey, whats up?', 'guf94', null, '25-APR-2015');
INSERT INTO MESSAGERECIPIENT values('71', 'guf94');
INSERT INTO MESSAGES values('72', 'bwf75', 'This message was generated in order to fill up the message table', 'vbt41', null, '2-MAR-2008');
INSERT INTO MESSAGERECIPIENT values('72', 'vbt41');
INSERT INTO MESSAGES values('73', 'qmk58', 'This message was generated in order to fill up the message table', 'lzx70', null, '9-MAY-2015');
INSERT INTO MESSAGERECIPIENT values('73', 'lzx70');
INSERT INTO MESSAGES values('74', 'nrk95', 'Hey, whats up?', 'gpv58', null, '14-JAN-2016');
INSERT INTO MESSAGERECIPIENT values('74', 'gpv58');
INSERT INTO MESSAGES values('75', 'vlx50', 'What do you think of Trump?', 'iah90', null, '26-SEP-2006');
INSERT INTO MESSAGERECIPIENT values('75', 'iah90');
INSERT INTO MESSAGES values('76', 'mvv9', 'This message was generated in order to fill up the message table', 'eyi68', null, '7-FEB-2011');
INSERT INTO MESSAGERECIPIENT values('76', 'eyi68');
INSERT INTO MESSAGES values('77', 'ewt76', 'I''m just sending this to fill the database', 'gjc33', null, '12-NOV-2016');
INSERT INTO MESSAGERECIPIENT values('77', 'gjc33');
INSERT INTO MESSAGES values('78', 'hed31', 'What do you think of Panos as a professor?', 'pqg2', null, '26-NOV-2005');
INSERT INTO MESSAGERECIPIENT values('78', 'pqg2');
INSERT INTO MESSAGES values('79', 'bwf75', 'What''s the point of this message?', 'gcr30', null, '18-OCT-2009');
INSERT INTO MESSAGERECIPIENT values('79', 'gcr30');
INSERT INTO MESSAGES values('80', 'uzu70', 'What do you think of Panos as a professor?', 'vlx50', null, '18-MAY-2009');
INSERT INTO MESSAGERECIPIENT values('80', 'vlx50');
INSERT INTO MESSAGES values('81', 'gyi100', 'I''m just sending this to fill the database', 'ssc60', null, '19-SEP-2016');
INSERT INTO MESSAGERECIPIENT values('81', 'ssc60');
INSERT INTO MESSAGES values('82', 'xwg21', 'Are there any good groups to join?', 'spq86', null, '19-NOV-2009');
INSERT INTO MESSAGERECIPIENT values('82', 'spq86');
INSERT INTO MESSAGES values('83', 'uly89', 'What do you think of Panos as a professor?', 'guf94', null, '5-OCT-2012');
INSERT INTO MESSAGERECIPIENT values('83', 'guf94');
INSERT INTO MESSAGES values('84', 'hye5', 'What do you think of Panos as a professor?', 'zsy35', null, '3-MAR-2009');
INSERT INTO MESSAGERECIPIENT values('84', 'zsy35');
INSERT INTO MESSAGES values('85', 'wux53', 'This message was generated in order to fill up the message table', 'zet73', null, '12-JAN-2006');
INSERT INTO MESSAGERECIPIENT values('85', 'zet73');
INSERT INTO MESSAGES values('86', 'esi7', 'What''s the point of this message?', 'ghm1', null, '12-NOV-2016');
INSERT INTO MESSAGERECIPIENT values('86', 'ghm1');
INSERT INTO MESSAGES values('87', 'upg89', 'What do you think of Trump?', 'imw75', null, '9-MAR-2006');
INSERT INTO MESSAGERECIPIENT values('87', 'imw75');
INSERT INTO MESSAGES values('88', 'pcj11', 'Is CS1555 a hard class?', 'gyi100', null, '26-NOV-2006');
INSERT INTO MESSAGERECIPIENT values('88', 'gyi100');
INSERT INTO MESSAGES values('89', 'qnz10', 'Is CS1555 a hard class?', 'oly50', null, '28-OCT-2007');
INSERT INTO MESSAGERECIPIENT values('89', 'oly50');
INSERT INTO MESSAGES values('90', 'uly89', 'Hey, whats up?', 'oly50', null, '13-FEB-2012');
INSERT INTO MESSAGERECIPIENT values('90', 'oly50');
INSERT INTO MESSAGES values('91', 'ccp6', 'I''m just sending this to fill the database', 'any88', null, '7-FEB-2007');
INSERT INTO MESSAGERECIPIENT values('91', 'any88');
INSERT INTO MESSAGES values('92', 'mrk30', 'What do you think of Panos as a professor?', 'imw75', null, '23-APR-2007');
INSERT INTO MESSAGERECIPIENT values('92', 'imw75');
INSERT INTO MESSAGES values('93', 'gjc33', 'What''s the point of this message?', 'fyb65', null, '10-NOV-2016');
INSERT INTO MESSAGERECIPIENT values('93', 'fyb65');
INSERT INTO MESSAGES values('94', 'mrk30', 'What do you think of Panos as a professor?', 'lnp65', null, '7-APR-2005');
INSERT INTO MESSAGERECIPIENT values('94', 'lnp65');
INSERT INTO MESSAGES values('95', 'vtv25', 'Are there any good groups to join?', 'jfm52', null, '6-DEC-2010');
INSERT INTO MESSAGERECIPIENT values('95', 'jfm52');
INSERT INTO MESSAGES values('96', 'jqa59', 'What do you think of Trump?', 'mes68', null, '5-DEC-2016');
INSERT INTO MESSAGERECIPIENT values('96', 'mes68');
INSERT INTO MESSAGES values('97', 'mdz20', 'Hey, whats up?', 'bhf42', null, '25-JUN-2014');
INSERT INTO MESSAGERECIPIENT values('97', 'bhf42');
INSERT INTO MESSAGES values('98', 'mvd44', 'Is CS1555 a hard class?', 'taj52', null, '12-JUL-2011');
INSERT INTO MESSAGERECIPIENT values('98', 'taj52');
INSERT INTO MESSAGES values('99', 'cwm65', 'What''s the point of this message?', 'gpv58', null, '10-AUG-2011');
INSERT INTO MESSAGERECIPIENT values('99', 'gpv58');
INSERT INTO MESSAGES values('100', 'ccp6', 'This message was generated in order to fill up the message table', 'ewt76', null, '18-NOV-2007');
INSERT INTO MESSAGERECIPIENT values('100', 'ewt76');
INSERT INTO MESSAGES values('101', 'bhf42', 'Hey, whats up?', 'wsb72', null, '8-AUG-2014');
INSERT INTO MESSAGERECIPIENT values('101', 'wsb72');
INSERT INTO MESSAGES values('102', 'mvd44', 'This message was generated in order to fill up the message table', 'trn95', null, '11-JUN-2005');
INSERT INTO MESSAGERECIPIENT values('102', 'trn95');
INSERT INTO MESSAGES values('103', 'vbt41', 'What do you think of Trump?', 'mvd44', null, '11-AUG-2007');
INSERT INTO MESSAGERECIPIENT values('103', 'mvd44');
INSERT INTO MESSAGES values('104', 'spq86', 'This message was generated in order to fill up the message table', 'lko38', null, '6-FEB-2011');
INSERT INTO MESSAGERECIPIENT values('104', 'lko38');
INSERT INTO MESSAGES values('105', 'ypw38', 'What do you think of Panos as a professor?', 'fpz13', null, '15-MAR-2007');
INSERT INTO MESSAGERECIPIENT values('105', 'fpz13');
INSERT INTO MESSAGES values('106', 'gyi100', 'What''s the point of this message?', 'hed31', null, '14-MAY-2006');
INSERT INTO MESSAGERECIPIENT values('106', 'hed31');
INSERT INTO MESSAGES values('107', 'upg89', 'Hey, whats up?', 'pcj11', null, '15-JUL-2013');
INSERT INTO MESSAGERECIPIENT values('107', 'pcj11');
INSERT INTO MESSAGES values('108', 'nig24', 'Are there any good groups to join?', 'cki84', null, '7-DEC-2005');
INSERT INTO MESSAGERECIPIENT values('108', 'cki84');
INSERT INTO MESSAGES values('109', 'guo28', 'This message was generated in order to fill up the message table', 'mvd44', null, '3-APR-2012');
INSERT INTO MESSAGERECIPIENT values('109', 'mvd44');
INSERT INTO MESSAGES values('110', 'lac65', 'What''s the point of this message?', 'rzq34', null, '3-FEB-2009');
INSERT INTO MESSAGERECIPIENT values('110', 'rzq34');
INSERT INTO MESSAGES values('111', 'nig24', 'What''s the point of this message?', 'ewt76', null, '12-NOV-2015');
INSERT INTO MESSAGERECIPIENT values('111', 'ewt76');
INSERT INTO MESSAGES values('112', 'aqq42', 'This message was generated in order to fill up the message table', 'uly89', null, '13-DEC-2007');
INSERT INTO MESSAGERECIPIENT values('112', 'uly89');
INSERT INTO MESSAGES values('113', 'kti55', 'What do you think of Panos as a professor?', 'eaa11', null, '9-SEP-2009');
INSERT INTO MESSAGERECIPIENT values('113', 'eaa11');
INSERT INTO MESSAGES values('114', 'ccp6', 'This message was generated in order to fill up the message table', 'hed31', null, '15-MAY-2007');
INSERT INTO MESSAGERECIPIENT values('114', 'hed31');
INSERT INTO MESSAGES values('115', 'bwf75', 'Hi, how are you doing?', 'noc45', null, '15-FEB-2005');
INSERT INTO MESSAGERECIPIENT values('115', 'noc45');
INSERT INTO MESSAGES values('116', 'hye5', 'What''s the point of this message?', 'kpp59', null, '9-SEP-2007');
INSERT INTO MESSAGERECIPIENT values('116', 'kpp59');
INSERT INTO MESSAGES values('117', 'hjh84', 'What do you think of Trump?', 'rzq34', null, '22-SEP-2006');
INSERT INTO MESSAGERECIPIENT values('117', 'rzq34');
INSERT INTO MESSAGES values('118', 'mbk60', 'What''s the point of this message?', 'bwf75', null, '2-FEB-2015');
INSERT INTO MESSAGERECIPIENT values('118', 'bwf75');
INSERT INTO MESSAGES values('119', 'jfm52', 'I''m just sending this to fill the database', 'wux53', null, '17-NOV-2013');
INSERT INTO MESSAGERECIPIENT values('119', 'wux53');
INSERT INTO MESSAGES values('120', 'vgs8', 'What do you think of Panos as a professor?', 'gjz90', null, '7-FEB-2014');
INSERT INTO MESSAGERECIPIENT values('120', 'gjz90');
INSERT INTO MESSAGES values('121', 'jnx15', 'Is CS1555 a hard class?', 'bjk39', null, '10-MAR-2009');
INSERT INTO MESSAGERECIPIENT values('121', 'bjk39');
INSERT INTO MESSAGES values('122', 'eyi68', 'What do you think of Panos as a professor?', 'mes68', null, '23-DEC-2016');
INSERT INTO MESSAGERECIPIENT values('122', 'mes68');
INSERT INTO MESSAGES values('123', 'mdz20', 'I''m just sending this to fill the database', 'vbt41', null, '18-JUN-2007');
INSERT INTO MESSAGERECIPIENT values('123', 'vbt41');
INSERT INTO MESSAGES values('124', 'fyb65', 'What''s the point of this message?', 'nnp98', null, '19-JUN-2015');
INSERT INTO MESSAGERECIPIENT values('124', 'nnp98');
INSERT INTO MESSAGES values('125', 'hye5', 'Are there any good groups to join?', 'qjr89', null, '14-SEP-2006');
INSERT INTO MESSAGERECIPIENT values('125', 'qjr89');
INSERT INTO MESSAGES values('126', 'glz95', 'Hi, how are you doing?', 'rzq34', null, '25-APR-2015');
INSERT INTO MESSAGERECIPIENT values('126', 'rzq34');
INSERT INTO MESSAGES values('127', 'mvd44', 'What do you think of Trump?', 'hjh84', null, '24-DEC-2010');
INSERT INTO MESSAGERECIPIENT values('127', 'hjh84');
INSERT INTO MESSAGES values('128', 'mvd44', 'Are there any good groups to join?', 'ewt76', null, '5-SEP-2011');
INSERT INTO MESSAGERECIPIENT values('128', 'ewt76');
INSERT INTO MESSAGES values('129', 'atz36', 'Hey, whats up?', 'taj52', null, '27-OCT-2015');
INSERT INTO MESSAGERECIPIENT values('129', 'taj52');
INSERT INTO MESSAGES values('130', 'pqr1', 'Are there any good groups to join?', 'ssc60', null, '13-JUL-2016');
INSERT INTO MESSAGERECIPIENT values('130', 'ssc60');
INSERT INTO MESSAGES values('131', 'bif47', 'What''s the point of this message?', 'ufq86', null, '25-MAY-2015');
INSERT INTO MESSAGERECIPIENT values('131', 'ufq86');
INSERT INTO MESSAGES values('132', 'lko38', 'Hey, whats up?', 'mbk60', null, '27-SEP-2015');
INSERT INTO MESSAGERECIPIENT values('132', 'mbk60');
INSERT INTO MESSAGES values('133', 'pqr1', 'Is CS1555 a hard class?', 'vlx50', null, '21-MAY-2006');
INSERT INTO MESSAGERECIPIENT values('133', 'vlx50');
INSERT INTO MESSAGES values('134', 'cki84', 'What do you think of Trump?', 'zsy35', null, '28-JUN-2012');
INSERT INTO MESSAGERECIPIENT values('134', 'zsy35');
INSERT INTO MESSAGES values('135', 'irq78', 'Hey, whats up?', 'nnp98', null, '24-AUG-2012');
INSERT INTO MESSAGERECIPIENT values('135', 'nnp98');
INSERT INTO MESSAGES values('136', 'jnx15', 'What do you think of Trump?', 'kpp59', null, '3-NOV-2008');
INSERT INTO MESSAGERECIPIENT values('136', 'kpp59');
INSERT INTO MESSAGES values('137', 'jfm52', 'Is CS1555 a hard class?', 'pqg2', null, '10-AUG-2015');
INSERT INTO MESSAGERECIPIENT values('137', 'pqg2');
INSERT INTO MESSAGES values('138', 'guo28', 'Is CS1555 a hard class?', 'kpp59', null, '21-OCT-2014');
INSERT INTO MESSAGERECIPIENT values('138', 'kpp59');
INSERT INTO MESSAGES values('139', 'nig24', 'What do you think of Trump?', 'cfn18', null, '5-JUN-2011');
INSERT INTO MESSAGERECIPIENT values('139', 'cfn18');
INSERT INTO MESSAGES values('140', 'hed31', 'I''m just sending this to fill the database', 'uly89', null, '2-MAR-2009');
INSERT INTO MESSAGERECIPIENT values('140', 'uly89');
INSERT INTO MESSAGES values('141', 'cwm65', 'What''s the point of this message?', 'jqa59', null, '20-JUN-2011');
INSERT INTO MESSAGERECIPIENT values('141', 'jqa59');
INSERT INTO MESSAGES values('142', 'fyb65', 'I''m just sending this to fill the database', 'cfn18', null, '12-JAN-2016');
INSERT INTO MESSAGERECIPIENT values('142', 'cfn18');
INSERT INTO MESSAGES values('143', 'xfi24', 'What''s the point of this message?', 'qmk58', null, '13-JAN-2009');
INSERT INTO MESSAGERECIPIENT values('143', 'qmk58');
INSERT INTO MESSAGES values('144', 'cfn18', 'I''m just sending this to fill the database', 'aqq42', null, '2-AUG-2009');
INSERT INTO MESSAGERECIPIENT values('144', 'aqq42');
INSERT INTO MESSAGES values('145', 'taj52', 'Hi, how are you doing?', 'eaa11', null, '11-SEP-2008');
INSERT INTO MESSAGERECIPIENT values('145', 'eaa11');
INSERT INTO MESSAGES values('146', 'ujo14', 'What do you think of Trump?', 'mvd44', null, '20-AUG-2007');
INSERT INTO MESSAGERECIPIENT values('146', 'mvd44');
INSERT INTO MESSAGES values('147', 'gpv58', 'Hi, how are you doing?', 'ssc60', null, '4-JAN-2011');
INSERT INTO MESSAGERECIPIENT values('147', 'ssc60');
INSERT INTO MESSAGES values('148', 'trn95', 'I''m just sending this to fill the database', 'jqa59', null, '18-JUN-2010');
INSERT INTO MESSAGERECIPIENT values('148', 'jqa59');
INSERT INTO MESSAGES values('149', 'mvd44', 'Are there any good groups to join?', 'ghm1', null, '23-APR-2006');
INSERT INTO MESSAGERECIPIENT values('149', 'ghm1');
INSERT INTO MESSAGES values('150', 'qnz10', 'I''m just sending this to fill the database', 'mvv9', null, '16-AUG-2007');
INSERT INTO MESSAGERECIPIENT values('150', 'mvv9');
INSERT INTO MESSAGES values('151', 'pqr1', 'Hey, whats up?', 'wde93', null, '8-SEP-2013');
INSERT INTO MESSAGERECIPIENT values('151', 'wde93');
INSERT INTO MESSAGES values('152', 'irq78', 'Hey, whats up?', 'xwg21', null, '24-JAN-2014');
INSERT INTO MESSAGERECIPIENT values('152', 'xwg21');
INSERT INTO MESSAGES values('153', 'tmg82', 'Is CS1555 a hard class?', 'obr28', null, '12-AUG-2006');
INSERT INTO MESSAGERECIPIENT values('153', 'obr28');
INSERT INTO MESSAGES values('154', 'jqa59', 'What do you think of Trump?', 'des7', null, '1-JUL-2010');
INSERT INTO MESSAGERECIPIENT values('154', 'des7');
INSERT INTO MESSAGES values('155', 'atz36', 'Hey, whats up?', 'wux53', null, '7-JUN-2010');
INSERT INTO MESSAGERECIPIENT values('155', 'wux53');
INSERT INTO MESSAGES values('156', 'bhf42', 'Hey, whats up?', 'upg89', null, '3-JUN-2009');
INSERT INTO MESSAGERECIPIENT values('156', 'upg89');
INSERT INTO MESSAGES values('157', 'vtv25', 'What''s the point of this message?', 'eyi68', null, '12-JUL-2005');
INSERT INTO MESSAGERECIPIENT values('157', 'eyi68');
INSERT INTO MESSAGES values('158', 'cxo76', 'This message was generated in order to fill up the message table', 'hcq44', null, '5-SEP-2011');
INSERT INTO MESSAGERECIPIENT values('158', 'hcq44');
INSERT INTO MESSAGES values('159', 'cki84', 'I''m just sending this to fill the database', 'nig24', null, '13-MAR-2010');
INSERT INTO MESSAGERECIPIENT values('159', 'nig24');
INSERT INTO MESSAGES values('160', 'des7', 'Hey, whats up?', 'bwf75', null, '25-NOV-2006');
INSERT INTO MESSAGERECIPIENT values('160', 'bwf75');
INSERT INTO MESSAGES values('161', 'jfm52', 'What''s the point of this message?', 'nnp98', null, '26-FEB-2013');
INSERT INTO MESSAGERECIPIENT values('161', 'nnp98');
INSERT INTO MESSAGES values('162', 'hkk63', 'Are there any good groups to join?', 'lko38', null, '17-FEB-2015');
INSERT INTO MESSAGERECIPIENT values('162', 'lko38');
INSERT INTO MESSAGES values('163', 'zet73', 'Hey, whats up?', 'goa89', null, '2-JUL-2016');
INSERT INTO MESSAGERECIPIENT values('163', 'goa89');
INSERT INTO MESSAGES values('164', 'vtv25', 'This message was generated in order to fill up the message table', 'ujo14', null, '26-AUG-2010');
INSERT INTO MESSAGERECIPIENT values('164', 'ujo14');
INSERT INTO MESSAGES values('165', 'irq78', 'This message was generated in order to fill up the message table', 'ccp6', null, '13-MAR-2007');
INSERT INTO MESSAGERECIPIENT values('165', 'ccp6');
INSERT INTO MESSAGES values('166', 'pcj11', 'What''s the point of this message?', 'des7', null, '6-MAY-2011');
INSERT INTO MESSAGERECIPIENT values('166', 'des7');
INSERT INTO MESSAGES values('167', 'kpp59', 'I''m just sending this to fill the database', 'jfm52', null, '8-APR-2013');
INSERT INTO MESSAGERECIPIENT values('167', 'jfm52');
INSERT INTO MESSAGES values('168', 'cbm65', 'Is CS1555 a hard class?', 'irq78', null, '8-JUL-2007');
INSERT INTO MESSAGERECIPIENT values('168', 'irq78');
INSERT INTO MESSAGES values('169', 'hkk63', 'This message was generated in order to fill up the message table', 'nrk95', null, '3-NOV-2010');
INSERT INTO MESSAGERECIPIENT values('169', 'nrk95');
INSERT INTO MESSAGES values('170', 'vgs8', 'This message was generated in order to fill up the message table', 'lac65', null, '14-NOV-2005');
INSERT INTO MESSAGERECIPIENT values('170', 'lac65');
INSERT INTO MESSAGES values('171', 'hru38', 'What''s the point of this message?', 'cbm65', null, '20-MAR-2011');
INSERT INTO MESSAGERECIPIENT values('171', 'cbm65');
INSERT INTO MESSAGES values('172', 'guo28', 'Are there any good groups to join?', 'cbm65', null, '21-JAN-2012');
INSERT INTO MESSAGERECIPIENT values('172', 'cbm65');
INSERT INTO MESSAGES values('173', 'hye5', 'Hi, how are you doing?', 'bhf42', null, '19-FEB-2007');
INSERT INTO MESSAGERECIPIENT values('173', 'bhf42');
INSERT INTO MESSAGES values('174', 'zet73', 'What do you think of Trump?', 'pqr1', null, '3-AUG-2011');
INSERT INTO MESSAGERECIPIENT values('174', 'pqr1');
INSERT INTO MESSAGES values('175', 'hcq44', 'Hey, whats up?', 'who78', null, '22-SEP-2009');
INSERT INTO MESSAGERECIPIENT values('175', 'who78');
INSERT INTO MESSAGES values('176', 'irq78', 'This message was generated in order to fill up the message table', 'tmx27', null, '8-JUL-2011');
INSERT INTO MESSAGERECIPIENT values('176', 'tmx27');
INSERT INTO MESSAGES values('177', 'nig24', 'Is CS1555 a hard class?', 'qjr89', null, '24-DEC-2009');
INSERT INTO MESSAGERECIPIENT values('177', 'qjr89');
INSERT INTO MESSAGES values('178', 'abh90', 'Is CS1555 a hard class?', 'gyi100', null, '17-MAY-2015');
INSERT INTO MESSAGERECIPIENT values('178', 'gyi100');
INSERT INTO MESSAGES values('179', 'mdz20', 'I''m just sending this to fill the database', 'jqa59', null, '5-FEB-2013');
INSERT INTO MESSAGERECIPIENT values('179', 'jqa59');
INSERT INTO MESSAGES values('180', 'gjz90', 'I''m just sending this to fill the database', 'xwg21', null, '25-APR-2014');
INSERT INTO MESSAGERECIPIENT values('180', 'xwg21');
INSERT INTO MESSAGES values('181', 'utk40', 'Is CS1555 a hard class?', 'cfn18', null, '25-SEP-2014');
INSERT INTO MESSAGERECIPIENT values('181', 'cfn18');
INSERT INTO MESSAGES values('182', 'ypw38', 'What do you think of Panos as a professor?', 'nrk95', null, '11-NOV-2015');
INSERT INTO MESSAGERECIPIENT values('182', 'nrk95');
INSERT INTO MESSAGES values('183', 'hcq44', 'Is CS1555 a hard class?', 'vgs8', null, '12-AUG-2016');
INSERT INTO MESSAGERECIPIENT values('183', 'vgs8');
INSERT INTO MESSAGES values('184', 'ccp6', 'Is CS1555 a hard class?', 'psf22', null, '22-JAN-2007');
INSERT INTO MESSAGERECIPIENT values('184', 'psf22');
INSERT INTO MESSAGES values('185', 'msf68', 'What do you think of Trump?', 'kti55', null, '13-NOV-2010');
INSERT INTO MESSAGERECIPIENT values('185', 'kti55');
INSERT INTO MESSAGES values('186', 'goa89', 'What do you think of Panos as a professor?', 'stb41', null, '26-AUG-2014');
INSERT INTO MESSAGERECIPIENT values('186', 'stb41');
INSERT INTO MESSAGES values('187', 'spq86', 'What''s the point of this message?', 'pcj11', null, '8-JUN-2008');
INSERT INTO MESSAGERECIPIENT values('187', 'pcj11');
INSERT INTO MESSAGES values('188', 'hed31', 'Is CS1555 a hard class?', 'bjk39', null, '25-MAR-2006');
INSERT INTO MESSAGERECIPIENT values('188', 'bjk39');
INSERT INTO MESSAGES values('189', 'eaa11', 'Are there any good groups to join?', 'stb41', null, '19-JAN-2012');
INSERT INTO MESSAGERECIPIENT values('189', 'stb41');
INSERT INTO MESSAGES values('190', 'hed31', 'This message was generated in order to fill up the message table', 'xwg21', null, '11-SEP-2014');
INSERT INTO MESSAGERECIPIENT values('190', 'xwg21');
INSERT INTO MESSAGES values('191', 'wde93', 'What do you think of Panos as a professor?', 'obr28', null, '21-FEB-2010');
INSERT INTO MESSAGERECIPIENT values('191', 'obr28');
INSERT INTO MESSAGES values('192', 'guf94', 'Hey, whats up?', 'qmk58', null, '5-MAR-2005');
INSERT INTO MESSAGERECIPIENT values('192', 'qmk58');
INSERT INTO MESSAGES values('193', 'mvd44', 'What do you think of Panos as a professor?', 'gyi100', null, '26-SEP-2016');
INSERT INTO MESSAGERECIPIENT values('193', 'gyi100');
INSERT INTO MESSAGES values('194', 'png51', 'Are there any good groups to join?', 'zet73', null, '13-FEB-2011');
INSERT INTO MESSAGERECIPIENT values('194', 'zet73');
INSERT INTO MESSAGES values('195', 'vlx50', 'Hi, how are you doing?', 'gpv58', null, '15-JAN-2015');
INSERT INTO MESSAGERECIPIENT values('195', 'gpv58');
INSERT INTO MESSAGES values('196', 'hkk63', 'Are there any good groups to join?', 'stb41', null, '7-JUN-2015');
INSERT INTO MESSAGERECIPIENT values('196', 'stb41');
INSERT INTO MESSAGES values('197', 'rzq34', 'Hey, whats up?', 'cfn18', null, '28-JUL-2010');
INSERT INTO MESSAGERECIPIENT values('197', 'cfn18');
INSERT INTO MESSAGES values('198', 'cbm65', 'What do you think of Panos as a professor?', 'cwm65', null, '16-SEP-2005');
INSERT INTO MESSAGERECIPIENT values('198', 'cwm65');
INSERT INTO MESSAGES values('199', 'guf94', 'What''s the point of this message?', 'imw75', null, '12-JUL-2010');
INSERT INTO MESSAGERECIPIENT values('199', 'imw75');
INSERT INTO MESSAGES values('200', 'eyi68', 'What''s the point of this message?', 'utk40', null, '20-JUN-2012');
INSERT INTO MESSAGERECIPIENT values('200', 'utk40');
INSERT INTO MESSAGES values('201', 'gpv58', 'Hey, whats up?', 'oly50', null, '3-MAY-2015');
INSERT INTO MESSAGERECIPIENT values('201', 'oly50');
INSERT INTO MESSAGES values('202', 'eyi68', 'Is CS1555 a hard class?', 'fyb65', null, '19-DEC-2006');
INSERT INTO MESSAGERECIPIENT values('202', 'fyb65');
INSERT INTO MESSAGES values('203', 'msf68', 'This message was generated in order to fill up the message table', 'qmk58', null, '8-OCT-2016');
INSERT INTO MESSAGERECIPIENT values('203', 'qmk58');
INSERT INTO MESSAGES values('204', 'irq78', 'Are there any good groups to join?', 'bif47', null, '5-MAR-2005');
INSERT INTO MESSAGERECIPIENT values('204', 'bif47');
INSERT INTO MESSAGES values('205', 'stb41', 'I''m just sending this to fill the database', 'esi7', null, '8-OCT-2006');
INSERT INTO MESSAGERECIPIENT values('205', 'esi7');
INSERT INTO MESSAGES values('206', 'zsy35', 'This message was generated in order to fill up the message table', 'wux53', null, '19-MAY-2010');
INSERT INTO MESSAGERECIPIENT values('206', 'wux53');
INSERT INTO MESSAGES values('207', 'mvv9', 'Is CS1555 a hard class?', 'vtv25', null, '21-JUL-2013');
INSERT INTO MESSAGERECIPIENT values('207', 'vtv25');
INSERT INTO MESSAGES values('208', 'abh90', 'What do you think of Trump?', 'rzq34', null, '6-FEB-2005');
INSERT INTO MESSAGERECIPIENT values('208', 'rzq34');
INSERT INTO MESSAGES values('209', 'esi7', 'Hey, whats up?', 'vtv25', null, '19-DEC-2010');
INSERT INTO MESSAGERECIPIENT values('209', 'vtv25');
INSERT INTO MESSAGES values('210', 'jnx15', 'What do you think of Panos as a professor?', 'eaa11', null, '3-AUG-2015');
INSERT INTO MESSAGERECIPIENT values('210', 'eaa11');
INSERT INTO MESSAGES values('211', 'kpp59', 'This message was generated in order to fill up the message table', 'lzx70', null, '3-JUL-2015');
INSERT INTO MESSAGERECIPIENT values('211', 'lzx70');
INSERT INTO MESSAGES values('212', 'vtv25', 'Are there any good groups to join?', 'ypw38', null, '19-FEB-2007');
INSERT INTO MESSAGERECIPIENT values('212', 'ypw38');
INSERT INTO MESSAGES values('213', 'gjz90', 'This message was generated in order to fill up the message table', 'lzx70', null, '28-JUN-2012');
INSERT INTO MESSAGERECIPIENT values('213', 'lzx70');
INSERT INTO MESSAGES values('214', 'glz95', 'What do you think of Panos as a professor?', 'jzv44', null, '20-JUL-2016');
INSERT INTO MESSAGERECIPIENT values('214', 'jzv44');
INSERT INTO MESSAGES values('215', 'zet73', 'What''s the point of this message?', 'mdz20', null, '7-SEP-2005');
INSERT INTO MESSAGERECIPIENT values('215', 'mdz20');
INSERT INTO MESSAGES values('216', 'cwm65', 'Hey, whats up?', 'spq86', null, '2-OCT-2013');
INSERT INTO MESSAGERECIPIENT values('216', 'spq86');
INSERT INTO MESSAGES values('217', 'upg89', 'Is CS1555 a hard class?', 'qnz10', null, '5-JUN-2013');
INSERT INTO MESSAGERECIPIENT values('217', 'qnz10');
INSERT INTO MESSAGES values('218', 'bwf75', 'I''m just sending this to fill the database', 'mvv9', null, '13-NOV-2014');
INSERT INTO MESSAGERECIPIENT values('218', 'mvv9');
INSERT INTO MESSAGES values('219', 'eyi68', 'What''s the point of this message?', 'zet73', null, '2-OCT-2013');
INSERT INTO MESSAGERECIPIENT values('219', 'zet73');
INSERT INTO MESSAGES values('220', 'kpp59', 'Are there any good groups to join?', 'uly89', null, '13-DEC-2015');
INSERT INTO MESSAGERECIPIENT values('220', 'uly89');
INSERT INTO MESSAGES values('221', 'atz36', 'I''m just sending this to fill the database', 'irq78', null, '12-MAY-2013');
INSERT INTO MESSAGERECIPIENT values('221', 'irq78');
INSERT INTO MESSAGES values('222', 'wux53', 'Hi, how are you doing?', 'ssc60', null, '20-APR-2011');
INSERT INTO MESSAGERECIPIENT values('222', 'ssc60');
INSERT INTO MESSAGES values('223', 'stb41', 'What do you think of Trump?', 'ccp6', null, '16-JUL-2005');
INSERT INTO MESSAGERECIPIENT values('223', 'ccp6');
INSERT INTO MESSAGES values('224', 'wsb72', 'This message was generated in order to fill up the message table', 'iah90', null, '15-OCT-2009');
INSERT INTO MESSAGERECIPIENT values('224', 'iah90');
INSERT INTO MESSAGES values('225', 'any88', 'Is CS1555 a hard class?', 'kpp59', null, '10-SEP-2011');
INSERT INTO MESSAGERECIPIENT values('225', 'kpp59');
INSERT INTO MESSAGES values('226', 'stb41', 'This message was generated in order to fill up the message table', 'pqg2', null, '27-NOV-2014');
INSERT INTO MESSAGERECIPIENT values('226', 'pqg2');
INSERT INTO MESSAGES values('227', 'qnz10', 'What''s the point of this message?', 'gyi100', null, '5-JAN-2010');
INSERT INTO MESSAGERECIPIENT values('227', 'gyi100');
INSERT INTO MESSAGES values('228', 'lzx70', 'What do you think of Trump?', 'trn95', null, '13-NOV-2016');
INSERT INTO MESSAGERECIPIENT values('228', 'trn95');
INSERT INTO MESSAGES values('229', 'mdz20', 'What do you think of Panos as a professor?', 'hye5', null, '16-FEB-2013');
INSERT INTO MESSAGERECIPIENT values('229', 'hye5');
INSERT INTO MESSAGES values('230', 'guf94', 'Are there any good groups to join?', 'mvd44', null, '19-AUG-2005');
INSERT INTO MESSAGERECIPIENT values('230', 'mvd44');
INSERT INTO MESSAGES values('231', 'jqa59', 'This message was generated in order to fill up the message table', 'lzx70', null, '9-JUL-2013');
INSERT INTO MESSAGERECIPIENT values('231', 'lzx70');
INSERT INTO MESSAGES values('232', 'eyi68', 'Hey, whats up?', 'zet73', null, '18-MAR-2013');
INSERT INTO MESSAGERECIPIENT values('232', 'zet73');
INSERT INTO MESSAGES values('233', 'any88', 'Is CS1555 a hard class?', 'mbk60', null, '23-MAR-2006');
INSERT INTO MESSAGERECIPIENT values('233', 'mbk60');
INSERT INTO MESSAGES values('234', 'hjh84', 'What''s the point of this message?', 'png51', null, '25-JUL-2011');
INSERT INTO MESSAGERECIPIENT values('234', 'png51');
INSERT INTO MESSAGES values('235', 'ewt76', 'What do you think of Panos as a professor?', 'obr28', null, '23-JUN-2011');
INSERT INTO MESSAGERECIPIENT values('235', 'obr28');
INSERT INTO MESSAGES values('236', 'ewt76', 'Hi, how are you doing?', 'hcq44', null, '19-APR-2016');
INSERT INTO MESSAGERECIPIENT values('236', 'hcq44');
INSERT INTO MESSAGES values('237', 'mvd44', 'Is CS1555 a hard class?', 'cwm65', null, '16-FEB-2005');
INSERT INTO MESSAGERECIPIENT values('237', 'cwm65');
INSERT INTO MESSAGES values('238', 'cwm65', 'What''s the point of this message?', 'des7', null, '2-APR-2009');
INSERT INTO MESSAGERECIPIENT values('238', 'des7');
INSERT INTO MESSAGES values('239', 'mvv9', 'What do you think of Trump?', 'noc45', null, '25-JUL-2010');
INSERT INTO MESSAGERECIPIENT values('239', 'noc45');
INSERT INTO MESSAGES values('240', 'iah90', 'This message was generated in order to fill up the message table', 'trn95', null, '18-OCT-2015');
INSERT INTO MESSAGERECIPIENT values('240', 'trn95');
INSERT INTO MESSAGES values('241', 'pqr1', 'What''s the point of this message?', 'pcj11', null, '12-MAR-2009');
INSERT INTO MESSAGERECIPIENT values('241', 'pcj11');
INSERT INTO MESSAGES values('242', 'esi7', 'Is CS1555 a hard class?', 'gyi100', null, '11-FEB-2011');
INSERT INTO MESSAGERECIPIENT values('242', 'gyi100');
INSERT INTO MESSAGES values('243', 'lnp65', 'Is CS1555 a hard class?', 'stb41', null, '17-APR-2009');
INSERT INTO MESSAGERECIPIENT values('243', 'stb41');
INSERT INTO MESSAGES values('244', 'uzu70', 'What do you think of Panos as a professor?', 'nrk95', null, '20-JUN-2011');
INSERT INTO MESSAGERECIPIENT values('244', 'nrk95');
INSERT INTO MESSAGES values('245', 'lnp65', 'Hey, whats up?', 'hjh84', null, '19-JUN-2007');
INSERT INTO MESSAGERECIPIENT values('245', 'hjh84');
INSERT INTO MESSAGES values('246', 'des7', 'Is CS1555 a hard class?', 'taj52', null, '11-OCT-2011');
INSERT INTO MESSAGERECIPIENT values('246', 'taj52');
INSERT INTO MESSAGES values('247', 'qnz10', 'Is CS1555 a hard class?', 'hed31', null, '5-MAY-2011');
INSERT INTO MESSAGERECIPIENT values('247', 'hed31');
INSERT INTO MESSAGES values('248', 'vgs8', 'This message was generated in order to fill up the message table', 'atz36', null, '12-SEP-2009');
INSERT INTO MESSAGERECIPIENT values('248', 'atz36');
INSERT INTO MESSAGES values('249', 'lzx70', 'What do you think of Panos as a professor?', 'xwg21', null, '6-MAY-2010');
INSERT INTO MESSAGERECIPIENT values('249', 'xwg21');
INSERT INTO MESSAGES values('250', 'irq78', 'This message was generated in order to fill up the message table', 'mdz20', null, '4-FEB-2008');
INSERT INTO MESSAGERECIPIENT values('250', 'mdz20');
INSERT INTO MESSAGES values('251', 'lac65', 'This message was generated in order to fill up the message table', 'any88', null, '6-OCT-2015');
INSERT INTO MESSAGERECIPIENT values('251', 'any88');
INSERT INTO MESSAGES values('252', 'gcr30', 'Is CS1555 a hard class?', 'spq86', null, '9-JUL-2009');
INSERT INTO MESSAGERECIPIENT values('252', 'spq86');
INSERT INTO MESSAGES values('253', 'atz36', 'This message was generated in order to fill up the message table', 'wsb72', null, '5-FEB-2007');
INSERT INTO MESSAGERECIPIENT values('253', 'wsb72');
INSERT INTO MESSAGES values('254', 'wsb72', 'I''m just sending this to fill the database', 'abh90', null, '12-AUG-2011');
INSERT INTO MESSAGERECIPIENT values('254', 'abh90');
INSERT INTO MESSAGES values('255', 'upg89', 'Are there any good groups to join?', 'guf94', null, '5-DEC-2006');
INSERT INTO MESSAGERECIPIENT values('255', 'guf94');
INSERT INTO MESSAGES values('256', 'utk40', 'This message was generated in order to fill up the message table', 'guf94', null, '7-MAY-2009');
INSERT INTO MESSAGERECIPIENT values('256', 'guf94');
INSERT INTO MESSAGES values('257', 'imw75', 'Hi, how are you doing?', 'vbt41', null, '14-JUN-2007');
INSERT INTO MESSAGERECIPIENT values('257', 'vbt41');
INSERT INTO MESSAGES values('258', 'guo28', 'What do you think of Trump?', 'nig24', null, '28-DEC-2007');
INSERT INTO MESSAGERECIPIENT values('258', 'nig24');
INSERT INTO MESSAGES values('259', 'gjz90', 'Is CS1555 a hard class?', 'png51', null, '18-DEC-2014');
INSERT INTO MESSAGERECIPIENT values('259', 'png51');
INSERT INTO MESSAGES values('260', 'taj52', 'Hey, whats up?', 'lko38', null, '7-FEB-2010');
INSERT INTO MESSAGERECIPIENT values('260', 'lko38');
INSERT INTO MESSAGES values('261', 'kpp59', 'What do you think of Trump?', 'mvv9', null, '23-NOV-2014');
INSERT INTO MESSAGERECIPIENT values('261', 'mvv9');
INSERT INTO MESSAGES values('262', 'jqa59', 'Is CS1555 a hard class?', 'tmg82', null, '1-FEB-2016');
INSERT INTO MESSAGERECIPIENT values('262', 'tmg82');
INSERT INTO MESSAGES values('263', 'obr28', 'What do you think of Panos as a professor?', 'ccp6', null, '26-OCT-2008');
INSERT INTO MESSAGERECIPIENT values('263', 'ccp6');
INSERT INTO MESSAGES values('264', 'fyb65', 'This message was generated in order to fill up the message table', 'nnp98', null, '21-APR-2010');
INSERT INTO MESSAGERECIPIENT values('264', 'nnp98');
INSERT INTO MESSAGES values('265', 'pcj11', 'I''m just sending this to fill the database', 'wux53', null, '13-FEB-2013');
INSERT INTO MESSAGERECIPIENT values('265', 'wux53');
INSERT INTO MESSAGES values('266', 'aqq42', 'What''s the point of this message?', 'mvv9', null, '11-FEB-2011');
INSERT INTO MESSAGERECIPIENT values('266', 'mvv9');
INSERT INTO MESSAGES values('267', 'obr28', 'I''m just sending this to fill the database', 'ewt76', null, '20-JUN-2006');
INSERT INTO MESSAGERECIPIENT values('267', 'ewt76');
INSERT INTO MESSAGES values('268', 'cki84', 'I''m just sending this to fill the database', 'kti55', null, '25-FEB-2014');
INSERT INTO MESSAGERECIPIENT values('268', 'kti55');
INSERT INTO MESSAGES values('269', 'fpz13', 'Is CS1555 a hard class?', 'gcr30', null, '16-NOV-2007');
INSERT INTO MESSAGERECIPIENT values('269', 'gcr30');
INSERT INTO MESSAGES values('270', 'jnx15', 'Hi, how are you doing?', 'goa89', null, '10-DEC-2012');
INSERT INTO MESSAGERECIPIENT values('270', 'goa89');
INSERT INTO MESSAGES values('271', 'mvv9', 'What do you think of Trump?', 'pqr1', null, '5-SEP-2007');
INSERT INTO MESSAGERECIPIENT values('271', 'pqr1');
INSERT INTO MESSAGES values('272', 'hjh84', 'Hey, whats up?', 'hru38', null, '25-FEB-2011');
INSERT INTO MESSAGERECIPIENT values('272', 'hru38');
INSERT INTO MESSAGES values('273', 'ujo14', 'Hey, whats up?', 'mes68', null, '22-SEP-2006');
INSERT INTO MESSAGERECIPIENT values('273', 'mes68');
INSERT INTO MESSAGES values('274', 'zet73', 'What''s the point of this message?', 'uly89', null, '5-OCT-2014');
INSERT INTO MESSAGERECIPIENT values('274', 'uly89');
INSERT INTO MESSAGES values('275', 'qjr89', 'This message was generated in order to fill up the message table', 'vgs8', null, '11-JUL-2009');
INSERT INTO MESSAGERECIPIENT values('275', 'vgs8');
INSERT INTO MESSAGES values('276', 'wde93', 'What do you think of Panos as a professor?', 'spq86', null, '9-MAY-2013');
INSERT INTO MESSAGERECIPIENT values('276', 'spq86');
INSERT INTO MESSAGES values('277', 'kpp59', 'What do you think of Trump?', 'esi7', null, '10-OCT-2016');
INSERT INTO MESSAGERECIPIENT values('277', 'esi7');
INSERT INTO MESSAGES values('278', 'fyb65', 'What''s the point of this message?', 'bif47', null, '26-FEB-2008');
INSERT INTO MESSAGERECIPIENT values('278', 'bif47');
INSERT INTO MESSAGES values('279', 'uly89', 'Hi, how are you doing?', 'guf94', null, '10-JAN-2005');
INSERT INTO MESSAGERECIPIENT values('279', 'guf94');
INSERT INTO MESSAGES values('280', 'guf94', 'What do you think of Panos as a professor?', 'noc45', null, '4-OCT-2015');
INSERT INTO MESSAGERECIPIENT values('280', 'noc45');
INSERT INTO MESSAGES values('281', 'bwf75', 'This message was generated in order to fill up the message table', 'vbt41', null, '23-APR-2012');
INSERT INTO MESSAGERECIPIENT values('281', 'vbt41');
INSERT INTO MESSAGES values('282', 'vlx50', 'This message was generated in order to fill up the message table', 'cki84', null, '28-SEP-2016');
INSERT INTO MESSAGERECIPIENT values('282', 'cki84');
INSERT INTO MESSAGES values('283', 'vbt41', 'This message was generated in order to fill up the message table', 'nrk95', null, '19-AUG-2010');
INSERT INTO MESSAGERECIPIENT values('283', 'nrk95');
INSERT INTO MESSAGES values('284', 'gjc33', 'Hi, how are you doing?', 'jzv44', null, '13-JAN-2008');
INSERT INTO MESSAGERECIPIENT values('284', 'jzv44');
INSERT INTO MESSAGES values('285', 'stb41', 'What''s the point of this message?', 'hru38', null, '11-AUG-2005');
INSERT INTO MESSAGERECIPIENT values('285', 'hru38');
INSERT INTO MESSAGES values('286', 'abh90', 'What do you think of Trump?', 'tmg82', null, '3-JUN-2009');
INSERT INTO MESSAGERECIPIENT values('286', 'tmg82');
INSERT INTO MESSAGES values('287', 'ghm1', 'Hey, whats up?', 'goa89', null, '19-SEP-2014');
INSERT INTO MESSAGERECIPIENT values('287', 'goa89');
INSERT INTO MESSAGES values('288', 'cxo76', 'Is CS1555 a hard class?', 'gpv58', null, '16-FEB-2012');
INSERT INTO MESSAGERECIPIENT values('288', 'gpv58');
INSERT INTO MESSAGES values('289', 'qjr89', 'I''m just sending this to fill the database', 'jnx15', null, '1-JAN-2010');
INSERT INTO MESSAGERECIPIENT values('289', 'jnx15');
INSERT INTO MESSAGES values('290', 'imw75', 'Is CS1555 a hard class?', 'vbt41', null, '2-FEB-2014');
INSERT INTO MESSAGERECIPIENT values('290', 'vbt41');
INSERT INTO MESSAGES values('291', 'ujo14', 'What do you think of Trump?', 'ghm1', null, '18-FEB-2010');
INSERT INTO MESSAGERECIPIENT values('291', 'ghm1');
INSERT INTO MESSAGES values('292', 'fpz13', 'I''m just sending this to fill the database', 'hye5', null, '15-MAY-2011');
INSERT INTO MESSAGERECIPIENT values('292', 'hye5');
INSERT INTO MESSAGES values('293', 'wde93', 'Is CS1555 a hard class?', 'any88', null, '3-MAY-2005');
INSERT INTO MESSAGERECIPIENT values('293', 'any88');
INSERT INTO MESSAGES values('294', 'gjz90', 'Hi, how are you doing?', 'esi7', null, '2-MAY-2014');
INSERT INTO MESSAGERECIPIENT values('294', 'esi7');
INSERT INTO MESSAGES values('295', 'trn95', 'Hey, whats up?', 'tmg82', null, '22-SEP-2012');
INSERT INTO MESSAGERECIPIENT values('295', 'tmg82');
INSERT INTO MESSAGES values('296', 'mes68', 'Is CS1555 a hard class?', 'nnp98', null, '1-NOV-2010');
INSERT INTO MESSAGERECIPIENT values('296', 'nnp98');
INSERT INTO MESSAGES values('297', 'hed31', 'Is CS1555 a hard class?', 'fyb65', null, '12-APR-2015');
INSERT INTO MESSAGERECIPIENT values('297', 'fyb65');
INSERT INTO MESSAGES values('298', 'gjc33', 'What do you think of Trump?', 'trn95', null, '18-JUL-2013');
INSERT INTO MESSAGERECIPIENT values('298', 'trn95');
INSERT INTO MESSAGES values('299', 'zet73', 'Is CS1555 a hard class?', 'esi7', null, '24-APR-2015');
INSERT INTO MESSAGERECIPIENT values('299', 'esi7');
INSERT INTO MESSAGES values('300', 'jnx15', 'Hi, how are you doing?', 'cwm65', null, '3-JAN-2013');
INSERT INTO MESSAGERECIPIENT values('300', 'cwm65');