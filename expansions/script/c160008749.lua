--Paintress Clay Dragon
	local cid,id=GetID()
function cid.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
end