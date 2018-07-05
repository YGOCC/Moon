--Medivatale Flora
function c160008802.initial_effect(c)
 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,10,c160008802.filter1,c160008802.filter2,1,99)
	c:EnableReviveLimit() 
end
function c160008802.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008802.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end
