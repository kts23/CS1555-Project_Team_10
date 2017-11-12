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
password        varchar2(50 )   not null deferrable,
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
CONSTRAINT FRIENDS_PK PRIMARY KEY (userID1, userID2) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT FRIENDS_FK1 FOREIGN KEY (userID1) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT FRIENDS_FK2 FOREIGN KEY (userID2) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING PENDINGFRIENDS TABLE
CREATE TABLE PENDINGFRIENDS(
fromID      varchar2(20)    not null deferrable,
toID        varchar2(20)    not null deferrable,
message     varchar2(200),
CONSTRAINT PENDINGFRIENDS_PK PRIMARY KEY (fromID, toID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGFRIENDS_FK1 FOREIGN KEY (fromID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGFRIENDS_FK2 FOREIGN KEY (toID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
); 

---CREATING GROUPS TABLE
CREATE TABLE GROUPS(
gID           varchar2(20)    not null deferrable,
name          varchar2(50)    not null deferrable,
description   varchar2(200),
CONSTRAINT GROUPS_PK PRIMARY KEY (gID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING GROUPMEMBERSHIP TABLE
CREATE TABLE GROUPMEMBERSHIP(
gID         varchar2(20)    not null deferrable,
userID      varchar2(50),
role        varchar2(20),
CONSTRAINT GROUPMEMBERSHIP_PK PRIMARY KEY (gID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT GROUPMEMBERSHIP_FK1 FOREIGN KEY (gID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT GROUPMEMBERSHIP_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING PENDINGGROUPMEMBERS TABLE
CREATE TABLE PENDINGGROUPMEMBERS(
gID         varchar2(20)    not null deferrable,
userID      varchar2(20)    not null deferrable,
message     varchar2(200),
CONSTRAINT PENDINGGROUPMEMBERS_PK PRIMARY KEY (gID, userID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGGROUPMEMBERS_FK1 FOREIGN KEY (gID) REFERENCES GROUPS(gID) INITIALLY IMMEDIATE DEFERRABLE,
CONSTRAINT PENDINGGROUPMEMBERS_FK2 FOREIGN KEY (userID) REFERENCES PROFILE(userID) INITIALLY IMMEDIATE DEFERRABLE
);

---CREATING MESSAGES TABLE
CREATE TABLE MESSAGES(
msgID       varchar2(20)    not null deferrable,
fromID      varchar2(20),  
message     varchar2(200),
toUserID    varchar2(20)    default null,
toGroupID   varchar2(20)    default null,
dateSent    date            not null deferrable,
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