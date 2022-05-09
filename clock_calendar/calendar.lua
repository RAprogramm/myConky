#!/usr/bin/env lua

Conky_color = "${color1}%2d${color0}"

T = os.date("*t", os.time())
Year, Month, Currentday = T.year, T.month, T.day

Daystart = os.date("*t", os.time({ year = Year, month = Month, day = 01 })).wday

Month_name = os.date("%B")

Days_in_month = {
	31,
	28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
}

LeapYear = function(year)
	return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

if LeapYear(Year) then
	Days_in_month[2] = 29
end

Title_start = (20 - (string.len(Month_name) + 5)) / 2

Title = string.rep(" ", math.floor(Title_start + 0.5)) -- add padding to center the title
	.. (" %s %s\n Su Mo Tu We Th Fr Sa\n"):format(Month_name, Year)

io.write(Title)

function Seq(a, b)
	if a > b then
		return
	else
		return a, Seq(a + 1, b)
	end
end

Days = Days_in_month[Month]

io.write(
	string.format(string.rep("   ", Daystart - 1) .. string.rep(" %2d", Days), Seq(1, Days))
		:gsub(string.rep(".", 21), "%0\n")
		:gsub(("%2d"):format(Currentday), (Conky_color):format(Currentday)) .. "\n"
)
