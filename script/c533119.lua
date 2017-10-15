--Mysterious Hyper Dragon
function c533119.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.FilterBoolFunction(Card.IsCode,533117))
	c:EnableReviveLimit()
end