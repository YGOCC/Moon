--Medivatale Deerady
function c160008789.initial_effect(c)
	aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,9,c160008789.filter1,c160008789.filter2,3,99)
	c:EnableReviveLimit() 
end
function c160008789.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008789.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end