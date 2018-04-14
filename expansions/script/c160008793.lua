--Medivatale Mermaid
function c160008793.initial_effect(c)
	aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,4,c160008793.filter1,c160008793.filter2)
	c:EnableReviveLimit() 
end
function c160008793.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008793.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end