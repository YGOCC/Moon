--CREATION Link Guardian Dragon
function c88880059.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x889),5,5,c88880059.lcheck)
	c:EnableReviveLimit()
	--(1)
	--(2)
	--(3)
end
function c88880059.lcheck(g)
	return (g:IsExists(Card.IsLinkType,1,nil,TYPE_XYZ) and g:IsExists(Card.IsLinkSetCard,1,nil,0x889))
end