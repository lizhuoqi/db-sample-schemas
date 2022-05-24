/*
tables, created by this order, dropped reversed.
==========================

artist 
album 
employee 
customer 
genre 
invoice 
media_type 
track 
invoice_line 
playlist 
playlist_track 

*/

-- ----------------------------
-- Table structure for artist
-- ----------------------------

CREATE TABLE artist (
  artist_id int4 NOT NULL,
  name varchar(120) ,
  primary key (artist_id)
)
;


-- ----------------------------
-- Table structure for album
-- ----------------------------

CREATE TABLE album (
  album_id int4 NOT NULL,
  title varchar(160)  NOT NULL,
  artist_id int4 NOT NULL,
  primary key (album_id),
  CONSTRAINT ablum_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
;

-- ----------------------------
-- Table structure for employee
-- ----------------------------

CREATE TABLE employee (
  employee_id int4 NOT NULL,
  last_name varchar(20)  NOT NULL,
  first_name varchar(20)  NOT NULL,
  title varchar(30) ,
  reports_to int4,
  birth_date timestamp(6),
  hire_date timestamp(6),
  address varchar(70) ,
  city varchar(40) ,
  state varchar(40) ,
  country varchar(40) ,
  postal_code varchar(10) ,
  phone varchar(24) ,
  fax varchar(24) ,
  email varchar(60) ,
  primary key (employee_id),
  CONSTRAINT employee_reports_to_fkey FOREIGN KEY (reports_to) REFERENCES employee (employee_id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
;

-- ----------------------------
-- Table structure for customer
-- ----------------------------

CREATE TABLE customer (
  customer_id int4 NOT NULL,
  first_name varchar(40)  NOT NULL,
  last_name varchar(20)  NOT NULL,
  company varchar(80) ,
  address varchar(70) ,
  city varchar(40) ,
  state varchar(40) ,
  country varchar(40) ,
  postal_code varchar(10) ,
  phone varchar(24) ,
  fax varchar(24) ,
  email varchar(60)  NOT NULL,
  support_rep_id int4,
  primary key (customer_id),
  CONSTRAINT customer_support_rep_id_fkey FOREIGN KEY (support_rep_id) REFERENCES employee (employee_id) ON DELETE NO ACTION ON UPDATE NO ACTION

)
;

-- ----------------------------
-- Table structure for genre
-- ----------------------------

CREATE TABLE genre (
  genre_id int4 NOT NULL,
  name varchar(120) ,
  primary key (genre_id)
)
;


-- ----------------------------
-- Table structure for invoice
-- ----------------------------

CREATE TABLE invoice (
  invoice_id int4 NOT NULL,
  customer_id int4 NOT NULL,
  invoice_date timestamp(6) NOT NULL,
  billing_address varchar(70) ,
  billing_city varchar(40) ,
  billing_state varchar(40) ,
  billing_country varchar(40) ,
  billing_postal_code varchar(10) ,
  total numeric(10,2) NOT NULL,
  primary key (invoice_id),
  CONSTRAINT invoice_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
;


-- ----------------------------
-- Table structure for media_type
-- ----------------------------

CREATE TABLE media_type (
  media_type_id int4 NOT NULL,
  name varchar(120) ,
  primary key (media_type_id)
)
;


-- ----------------------------
-- Table structure for track
-- ----------------------------

CREATE TABLE track (
  track_id int4 NOT NULL,
  name varchar(200)  NOT NULL,
  album_id int4,
  media_type_id int4 NOT NULL,
  genre_id int4,
  composer varchar(220) ,
  milliseconds int4 NOT NULL,
  bytes int4,
  unit_price numeric(10,2) NOT NULL,
  primary key (track_id),
  CONSTRAINT track_album_id_fkey FOREIGN KEY (album_id) REFERENCES album (album_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT track_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT track_media_type_id_fkey FOREIGN KEY (media_type_id) REFERENCES media_type (media_type_id) ON DELETE NO ACTION ON UPDATE NO ACTION

)
;

-- ----------------------------
-- Table structure for invoice_line
-- ----------------------------

CREATE TABLE invoice_line (
  invoice_line_id int4 NOT NULL,
  invoice_id int4 NOT NULL,
  track_id int4 NOT NULL,
  unit_price numeric(10,2) NOT NULL,
  quantity int4 NOT NULL,
  primary key (invoice_line_id),
  CONSTRAINT invoice_line_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES invoice (invoice_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT invoice_line_track_id_fkey FOREIGN KEY (track_id) REFERENCES track (track_id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
;

-- ----------------------------
-- Table structure for playlist
-- ----------------------------

CREATE TABLE playlist (
  playlist_id int4 NOT NULL,
  Name varchar(120) ,
  primary key (playlist_id)
)
;


-- ----------------------------
-- Table structure for playlist_track
-- ----------------------------

CREATE TABLE playlist_track (
  playlist_id int4 NOT NULL,
  track_id int4 NOT NULL,
  primary key (playlist_id, track_id),
  CONSTRAINT playlist_track_playlist_id_fkey FOREIGN KEY (playlist_id) REFERENCES playlist (playlist_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT playlist_track_track_id_fkey FOREIGN KEY (track_id) REFERENCES track (track_id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
;

