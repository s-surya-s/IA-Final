INSERT INTO citibike_dw.date_dim (date, year, quarter, month, week, day, hour)
SELECT DATE(started_at), YEAR(started_at), QUARTER(started_at), MONTH(started_at), DAY(started_at), HOUR(started_at) FROM  citibike_db.data
GROUP BY 1,2,3,4,5,6
ORDER BY 1,6;

INSERT INTO citibike_dw.member_type_dim (member_type_desc)
SELECT member_casual
FROM citibike_db.data
GROUP BY 1;

INSERT INTO citibike_dw.rideable_type_dim (rideable_type_desc)
SELECT rideable_type
FROM citibike_db.data
GROUP BY 1; 

INSERT INTO citibike_dw.station_dim (station_id, station_name)
SELECT start_station_id, start_station_name
FROM citibike_db.data
GROUP BY 1,2;

INSERT INTO citibike_dw.weather_dim (weather_name) 
SELECT icon
FROM citibike_db.data
GROUP BY 1; 

INSERT INTO citibike_dw.rides_fact (date_sk_id, station_sk_id, member_type_sk_id, rideable_type_sk_id, weather_sk_id, total_usage_hours, total_rides_count, total_fare)
SELECT 
date_sk_id,
station_sk_id,
member_type_sk_id,
rideable_type_sk_id,
weather_sk_id, 
sum(ride_duration), 
count(*), 
sum(fare)
FROM citibike_db.data A
JOIN citibike_dw.date_dim dat ON date(A.started_at) = dat.date AND hour(A.started_at) = dat.hour
JOIN citibike_dw.member_type_dim mem ON A.member_casual =  mem.member_type_desc
JOIN citibike_dw.rideable_type_dim rid ON A.rideable_type = rid.rideable_type_desc
JOIN citibike_dw.station_dim stn ON A.start_station_name = stn.station_name
JOIN citibike_dw.weather_dim wth ON A.icon = wth.weather_name
GROUP BY 1,2,3,4,5;