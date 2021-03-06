
--Check if data is imported Correctly
SELECT *
FROM Monkeypox..Monkeypox_Symptoms

--Confirmed Cases that are hospitalized
SELECT Country, Gender,[Age Brackets], [Hospitalised (Y/N/NA)]
FROM Monkeypox..Monkeypox_Symptoms
WHERE Status = 'Confirmed'
AND [Hospitalised (Y/N/NA)] = 'Y'
ORDER BY Country

--Cases that show particular Symptoms of the Disease
SELECT Country, Symptoms1, Symptoms2, Symptoms3, Symptoms4
FROM Monkeypox..Monkeypox_Symptoms
WHERE Symptoms1 like '%lesions%' OR Symptoms2 like '%lesions%'
OR Symptoms3 like '%lesions%' OR Symptoms4 like '%lesions%'
AND Status = 'confirmed'
ORDER BY Country

--Total cases in each age Group (Suspected and Confirmed)
SELECT [Age Brackets], COUNT(Status) AS Cases
FROM Monkeypox..Monkeypox_Symptoms
--WHERE Status= 'Confirmed'
GROUP BY [Age Brackets]

--Total count of Confirmed Cases in each country
SELECT Country As Location, COUNT(Status) AS ConfirmedCases
FROM Monkeypox..Monkeypox_Symptoms
WHERE Status= 'confirmed'
GROUP BY Country

--Global count of confirmed Cases
SELECT  'Globally' AS Location, SUM(COUNT(Status)) OVER() AS TotalCases
FROM Monkeypox..Monkeypox_Symptoms
WHERE Status= 'confirmed'

-- Confirmed cases that had to be hospitalized and travel history status
SELECT symp.Country,symp.Date_confirmation, symp.[Hospitalised (Y/N/NA)] , 
travel.Travel_history_country, travel.[Travel_history (Y/N/NA)], travel.Confirmation_method
FROM Monkeypox..Monkeypox_Symptoms symp
JOIN Monkeypox..Monkeypox_TravelHistory travel
 ON symp.Country= travel.Country
WHERE symp.Status = 'Confirmed'
AND symp.[Hospitalised (Y/N/NA)] = 'Y'
--AND travel.[Travel_history (Y/N/NA)] = 'Y'
ORDER BY symp.Country