--Medivatale Blue Angel
function c160008800.initial_effect(c)
 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,6,c160008800.filter1,c160008800.filter2,2,99)
	c:EnableReviveLimit() 
end
function c160008800.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008800.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end
