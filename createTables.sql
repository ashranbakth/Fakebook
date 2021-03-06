CREATE TABLE USERS (
	USER_ID NUMBER, -- auto increment
	FIRST_NAME VARCHAR2(100) NOT NULL,
	LAST_NAME VARCHAR2(100) NOT NULL,
	YEAR_OF_BIRTH INTEGER,
	MONTH_OF_BIRTH INTEGER,
	DAY_OF_BIRTH INTEGER,
	GENDER VARCHAR2(100),
	PRIMARY KEY(USER_ID)
);

CREATE TABLE FRIENDS (
	USER1_ID NUMBER,
	USER2_ID NUMBER, 
	PRIMARY KEY (USER1_ID, USER2_ID),
	FOREIGN KEY (USER1_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (USER2_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE 
);
----------------------------------------------------------------------------------
CREATE TABLE CITIES ( 
	CITY_ID INTEGER,
	CITY_NAME VARCHAR2(100),
	STATE_NAME VARCHAR2(100),
	COUNTRY_NAME VARCHAR2(100),
	PRIMARY KEY(CITY_ID)
);

CREATE TABLE USER_CURRENT_CITY (
	USER_ID NUMBER,
	CURRENT_CITY_ID INTEGER,
	PRIMARY KEY(USER_ID),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (CURRENT_CITY_ID) REFERENCES CITIES(CITY_ID) ON DELETE CASCADE
);

CREATE TABLE USER_HOMETOWN_CITY (
	USER_ID NUMBER,
	HOMETOWN_CITY_ID INTEGER,
	PRIMARY KEY(USER_ID),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (HOMETOWN_CITY_ID) REFERENCES CITIES(CITY_ID) ON DELETE CASCADE
);
----------------------------------------------------------------------------------
CREATE TABLE MESSAGE (-- ASK QUESTIONS ABOUT NOT NULL FOR SENDER_ID, RECEIVER_ID, SENT_TIME
   MESSAGE_ID INTEGER,
   SENDER_ID NUMBER NOT NULL,
   RECEIVER_ID NUMBER NOT NULL,
   MESSAGE_CONTENT VARCHAR2(2000),
   SENT_TIME TIMESTAMP,
	PRIMARY KEY(MESSAGE_ID),
	FOREIGN KEY (SENDER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (RECEIVER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE 
);
----------------------------------------------------------------------------------
CREATE TABLE PROGRAMS (
	PROGRAM_ID INTEGER, 
	INSTITUTION VARCHAR2(100),
	CONCENTRATION VARCHAR2(100),
	DEGREE VARCHAR2(100),
	PRIMARY KEY(PROGRAM_ID)
);

CREATE TABLE EDUCATION (
	USER_ID NUMBER,
	PROGRAM_ID INTEGER,
	PROGRAM_YEAR INTEGER,
   PRIMARY KEY(USER_ID, PROGRAM_ID, PROGRAM_YEAR),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (PROGRAM_ID) REFERENCES PROGRAMS(PROGRAM_ID) ON DELETE CASCADE 
);
----------------------------------------------------------------------------------
CREATE TABLE USER_EVENTS (
	EVENT_ID NUMBER,
	EVENT_CREATOR_ID NUMBER NOT NULL,
	EVENT_NAME VARCHAR2(100) NOT NULL,
	EVENT_TAGLINE VARCHAR2(100),
	EVENT_DESCRIPTION VARCHAR2(100),
	EVENT_HOST VARCHAR2(100) NOT NULL,
	EVENT_TYPE VARCHAR2(100) NOT NULL, --CHOICES?
	EVENT_SUBTYPE VARCHAR2(100) NOT NULL,
	EVENT_LOCATION VARCHAR2(100),
	EVENT_CITY_ID INTEGER,
	EVENT_START_TIME TIMESTAMP NOT NULL,
	EVENT_END_TIME TIMESTAMP NOT NULL,
	PRIMARY KEY(EVENT_ID),
	FOREIGN KEY (EVENT_CREATOR_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (EVENT_CITY_ID) REFERENCES CITIES(CITY_ID) ON DELETE CASCADE
);

CREATE TABLE PARTICIPANTS (
   EVENT_ID NUMBER,
   USER_ID NUMBER,
   CONFIRMATION VARCHAR2(100) NOT NULL,
	PRIMARY KEY(EVENT_ID, USER_ID),
	FOREIGN KEY (EVENT_ID) REFERENCES USER_EVENTS(EVENT_ID) ON DELETE CASCADE,
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	CONSTRAINT  confirmation_constraint CHECK ((CONFIRMATION = 'attending') 
		OR (CONFIRMATION = 'declined') 
		OR (CONFIRMATION = 'unsure') 
		OR (CONFIRMATION = 'not-replied'))
);
----------------------------------------------------------------------------------
CREATE TABLE ALBUMS (
    ALBUM_ID VARCHAR2(100),
    ALBUM_OWNER_ID NUMBER NOT NULL,
    ALBUM_NAME VARCHAR2(100) NOT NULL,
    ALBUM_CREATED_TIME INT,
    ALBUM_MODIFIED_TIME INT,
    ALBUM_LINK VARCHAR2(2000),
    ALBUM_VISIBILITY VARCHAR2(100) NOT NULL,
    COVER_PHOTO_ID VARCHAR2(100) NOT NULL,
	PRIMARY KEY(ALBUM_ID),
	FOREIGN KEY (ALBUM_OWNER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	--FOREIGN KEY IN LOAD DATA
);

CREATE TABLE PHOTOS (
	PHOTO_ID VARCHAR2(100),
   ALBUM_ID VARCHAR2(100) NOT NULL,
   PHOTO_CAPTION VARCHAR2(2000),
   PHOTO_CREATED_TIME INT,
   PHOTO_MODIFIED_TIME INT,
   PHOTO_LINK VARCHAR2(2000) NOT NULL,
	PRIMARY KEY(PHOTO_ID) -- foreingn key in load data
);



CREATE TABLE TAGS (
	TAG_PHOTO_ID VARCHAR2(100) NOT NULL,
   TAG_SUBJECT_ID NUMBER, --not null?
   TAG_CREATED_TIME INT,
   TAG_X NUMBER NOT NULL,
   TAG_Y NUMBER NOT NULL,
	PRIMARY KEY(TAG_SUBJECT_ID, TAG_PHOTO_ID),
	FOREIGN KEY (TAG_SUBJECT_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (TAG_PHOTO_ID) REFERENCES PHOTOS(PHOTO_ID) ON DELETE CASCADE
);
----------------------------------------------------------------------------------
-- city_id auto increment
CREATE SEQUENCE city_sequence
START WITH 1
INCREMENT BY 1;
CREATE TRIGGER city_sequence_trigger
BEFORE INSERT ON CITIES
FOR EACH ROW
BEGIN
  SELECT city_sequence.NEXTVAL
  INTO :NEW.CITY_ID
  FROM DUAL;
END;
/

-- program_id auto increment
CREATE SEQUENCE program_sequence
START WITH 1
INCREMENT BY 1;
CREATE TRIGGER program_sequence_trigger
BEFORE INSERT ON PROGRAMS
FOR EACH ROW
BEGIN
  SELECT program_sequence.NEXTVAL
  INTO :NEW.PROGRAM_ID
  FROM DUAL;
END;
/

CREATE TRIGGER friends_trigger
BEFORE INSERT ON FRIENDS
FOR EACH ROW
DECLARE
	temp_id number;
BEGIN 
	IF :NEW.USER1_ID > :NEW.USER2_ID THEN
		temp_id := :NEW.USER1_ID;
		:NEW.USER1_ID := :NEW.USER2_ID;
		:NEW.USER2_ID := temp_id;
	END IF;
END;
/
	
                                                                                                                    

