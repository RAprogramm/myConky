#!/usr/bin/lua

Http = require("socket.http")
Json = require("dkjson")

Api_url = "http://api.openweathermap.org/data/2.5/weather?"
Cityid = "1835967"
Cf = "metric"
Apikey = "a922759611d54fd96a77e12284412d4b"
Measure = "°" .. (Cf == "metric" and "C" or "F")
Wind_units = (Cf == "metric" and " meter/sec" or "mph")
Pressure_units = (Cf == "metric" and " hPa" or "mph")

Currenttime = os.date("!%Y%m%d%H%M%S")

File_exists = function(name)
	F = io.open(name, "r")
	if F ~= nil then
		io.close(F)
		return true
	else
		return false
	end
end

if File_exists("weather.json") then
	Cache = io.open("weather.json", "r")
	Data = Json.decode(Cache:read())
	Cache.close(Cache)
	Timepassed = os.difftime(Currenttime, Data.timestamp)
else
	Timepassed = 6000
end

Makecache = function(s)
	Cache = io.open("weather.json", "w+")
	s.timestamp = Currenttime
	Save = Json.encode(s)
	Cache:write(Save)
	Cache.close(Cache)
end

if Timepassed < 3600 then
	Response = Data
else
	Weather = Http.request(("%sid=%s&units=%s&APPID=%s"):format(Api_url, Cityid, Cf, Apikey))
	if Weather then
		Response = Json.decode(Weather)
		Makecache(Response)
	else
		Response = Data
	end
end

math.round = function(n)
	return math.floor(n + 0.5)
end

Degrees_to_direction = function(d)
	Val = math.round(d / 22.5)
	Directions = { "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW" }
	return Directions[Val % 16]
end

Temp = Response.main.temp
Conditions = Response.weather[1].description
Icon = Response.weather[1].id
Pressure = Response.main.pressure
Humidity = Response.main.humidity
Wind = Response.wind.speed
Deg = Degrees_to_direction(Response.wind.deg)
Sunrise = os.date("%H:%M", Response.sys.sunrise)
Sunset = os.date("%H:%M", Response.sys.sunset)

Conky_text = [[
${font2}${color2}│
${font2}${color2}│
${font2}${color2}│
${font2}${color2}│
${font2}${color2}│
${font2}${color2}│${image ~/.config/conky/weather/icons/%s.png -p 20,57 -s 80x80}${color1}${font :size=25} ${voffset -40}${offset 100}%s%s${color}
  ${voffset -16}$font2$color2────────────────$color0
${voffset -2}${font2}${color2}│$font$color0         ${font3}%s
${font2}${color2}│
${font2}${color2}│ ${font4}${color0}Pressure: $font${color1}%s %s${color}
${font2}${color2}│ ${font4}${color0}Humidity: $font${color1}%s%%${color}
${font2}${color2}│ ${font4}${color0}Wind: $font${color1}%s%s %s${color}
${font2}${color2}│
${font2}${color2}│    ${font}${color}sunrise           sunset
${font2}${color2}│${image ~/.config/conky/weather/icons/sunrise.png -p 65,263 -s 32x32}    ${color1}%s${color}    ${image ~/.config/conky/weather/icons/sunset.png -p 165,263 -s 32x32}${color1}%s${color}
]]

io.write(
	(Conky_text):format(
		Icon,
		math.round(Temp),
		Measure,
		Conditions,
		Pressure,
		Pressure_units,
		Humidity,
		math.round(Wind),
		Wind_units,
		Deg,
		Sunrise,
		Sunset
	)
)
