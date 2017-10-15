--Double-Faced Dog
function c50031665.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),2,2)
	c:EnableReviveLimit()  
end
