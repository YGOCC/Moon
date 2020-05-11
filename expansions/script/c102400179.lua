--created & coded by Lyris
--フェイツ儀式術
local cid,id=GetID()
function cid.initial_effect(c)
	aux.AddRitualProcGreater(c,aux.FilterBoolFunction(Card.IsSetCard,0xf7a))
end
