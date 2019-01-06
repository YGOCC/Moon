--Medivatale Onibear
function c160008788.initial_effect(c)
 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,6,c160008788.filter1,c160008788.filter2,2,99)
	c:EnableReviveLimit() 
end
function c160008788.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008788.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end
