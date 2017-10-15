--Gilgamesh, Traitorous King of Eternal Flames
function c35697494.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c35697494.ffilter,3,false)
end
function c35697494.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) 
end