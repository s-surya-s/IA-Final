DROP SCHEMA IF EXISTS citibike_dw;
CREATE SCHEMA citibike_dw;

CREATE  TABLE citibike_dw.date_dim ( 
	date_sk_id           INT    NOT NULL   PRIMARY KEY AUTO_INCREMENT,
	`date`               DATE    NOT NULL   ,
	year                 INT    NOT NULL   ,
	quarter              INT    NOT NULL   ,
	month                INT    NOT NULL   ,
	day                  INT    NOT NULL   ,
	hour                 INT    NOT NULL   
 );

CREATE  TABLE citibike_dw.member_type_dim ( 
	member_type_sk_id   INT    NOT NULL   PRIMARY KEY AUTO_INCREMENT,
	member_type_desc     TEXT    NOT NULL   
 );

CREATE  TABLE citibike_dw.rideable_type_dim ( 
	rideable_type_sk_id  INT    NOT NULL   PRIMARY KEY AUTO_INCREMENT,
	rideable_type_desc   TEXT    NOT NULL   
 );

CREATE  TABLE citibike_dw.station_dim ( 
	station_sk_id        INT    NOT NULL   PRIMARY KEY AUTO_INCREMENT,
	station_id           INT    NOT NULL   ,
	station_name         VARCHAR(100)    NOT NULL 
 );

CREATE  TABLE citibike_dw.weather_dim ( 
	weather_sk_id        INT    NOT NULL   PRIMARY KEY AUTO_INCREMENT,
	weather_name         VARCHAR(100)    NOT NULL   
 );
 
 CREATE  TABLE citibike_dw.rides_fact ( 
	date_sk_id           INT    NOT NULL   ,
	station_sk_id        INT    NOT NULL   ,
	member_type_sk_id    INT    NOT NULL   ,
	rideable_type_sk_id  INT    NOT NULL   ,
	weather_sk_id        INT    NOT NULL   ,
	total_usage_hours    FLOAT    NOT NULL   ,
	total_rides_count    INT    NOT NULL   ,
	total_fare           FLOAT    NOT NULL   ,
	CONSTRAINT pk_ride_fact PRIMARY KEY ( date_sk_id, station_sk_id, member_type_sk_id, rideable_type_sk_id, weather_sk_id ),
    FOREIGN KEY (date_sk_id) 			REFERENCES citibike_dw.date_dim(date_sk_id),
    FOREIGN KEY (station_sk_id)		 	REFERENCES citibike_dw.station_dim(station_sk_id),
    FOREIGN KEY (member_type_sk_id) 	REFERENCES citibike_dw.member_type_dim(member_type_sk_id),
    FOREIGN KEY (rideable_type_sk_id) 	REFERENCES citibike_dw.rideable_type_dim(rideable_type_sk_id),
    FOREIGN KEY (weather_sk_id) 		REFERENCES citibike_dw.weather_dim(weather_sk_id)
 );