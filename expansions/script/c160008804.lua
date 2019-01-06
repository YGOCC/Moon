--Medivatale Mad Hatter
function c160008804.initial_effect(c)
 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,3,c160008804.filter1,c160008804.filter2,1,99)
	c:EnableReviveLimit() 
end
function c160008804.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008804.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end
