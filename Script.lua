--https://github.com/The-Glit-ch
--Script that gets you weather info
--Reaplce "Cords" with your cordinates(can be found here => https://www.google.com/maps)

local HTTP = game:GetService("HttpService")

local Cords = "latitude,longitude"
--
function GetAndDecode(URL,Cache,Headers)
	local ServerRes = HTTP:GetAsync(URL,Cache,Headers)
	local Decode = HTTP:JSONDecode(ServerRes)
	return Decode
end

function GetCityAndState(JSON)
	return JSON.properties.relativeLocation.properties.city,JSON.properties.relativeLocation.properties.state
end

function GetForecast(JSON)
	local Periods = JSON.properties.periods[1]
	--Tuple Return Name,Tempature,WindSpeed,WindDirection,ForecastDesc
	print()
	return Periods.name,Periods.temperature,Periods.windSpeed,Periods.windDirection,Periods.detailedForecast
end

function SetWeatherData(City,State,Name,Tempature,WindSpeed,WindDirection,ForecastDesc)
	local LocationTitle_Text = script.Parent.LocationTitle
	local Tempature_Text = script.Parent.Tempature
	local Currently_Text = script.Parent.Currently
	local WindSpeed_Text = Currently_Text.WindSpeed
	local WindDirection_Text = Currently_Text.WindDirection
	local ForecastDesc_Text = Currently_Text.ForecastDesc
	
	LocationTitle_Text.Text = City..","..State..""
	Tempature_Text.Text = Tempature.."°F"
	Currently_Text.Text = Name
	WindSpeed_Text.Text = "Wind Speed: "..WindSpeed
	WindDirection_Text.Text = "Wind Direction: "..WindDirection
	ForecastDesc_Text.Text = ForecastDesc
end


local HTTPCheck = GetAndDecode("https://api.weather.gov/")

if HTTPCheck.status == "OK" then
	print("HTTP is enabled now moving on")
	local FormattedURL = string.format("https://api.weather.gov/points/%s",Cords)
	local Point = GetAndDecode(FormattedURL)
	print("Got point data")
	local City,State = GetCityAndState(Point)
	print("Got city and state")
	local Forecast = GetAndDecode(Point.properties.forecast)
	print("Got forecast")
	local Name, Tempature, WindSpeed, WindDirection, ForecastDesc = GetForecast(Forecast)
	print("Got forecast data")
	print(Tempature,Name, Tempature, WindSpeed, WindDirection, ForecastDesc)
	SetWeatherData(City,State,Name,Tempature,WindSpeed,WindDirection,ForecastDesc)
	
else
	warn("WARNING: HTTP is disabled, please enebale it")
end
