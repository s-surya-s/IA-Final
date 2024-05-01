DROP SCHEMA IF EXISTS citibike_db;
CREATE SCHEMA citibike_db;

CREATE  TABLE citibike_db.data ( 
 ride_id                TEXT    NOT NULL,
 rideable_type          TEXT    NOT NULL,
 started_at             DATETIME    NOT NULL,
 ended_at               DATETIME    NOT NULL,
 start_station_name     TEXT    NOT NULL,
 start_station_id       TEXT    NOT NULL,
 end_station_name       TEXT    NOT NULL,
 end_station_id         TEXT    NOT NULL,
 start_lat              TEXT    NOT NULL,
 start_lng              TEXT    NOT NULL,
 end_lat                TEXT    NOT NULL,
 end_lng                TEXT    NOT NULL,
 member_casual          TEXT    NOT NULL,
 ride_date              DATE    NOT NULL,
 ride_hour              INT     NOT NULL,
 temp                   FLOAT4  NOT NULL,
 icon                   TEXT    NOT NULL,
 ride_duration			FLOAT4  NOT NULL,
 fare					FLOAT4  NOT NULL
 );