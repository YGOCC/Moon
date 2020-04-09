--Paintress Georigina
local cid,id=GetID()
function cid.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,cid.mfilter,4,3)
	c:EnableReviveLimit()  
end
function cid.mfilter(c)
	return not c:IsType(TYPE_EFFECT)
end