--Paintress Clay Dragon
local cid,id=GetID()
function cid.initial_effect(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cid.ffilter,2,false)
end
function cid.ffilter(c)
	return  not c:IsType(TYPE_EFFECT)
end