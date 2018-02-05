--Ritual der aufkommenden Luft
function c10100030.initial_effect(c)
	aux.AddRitualProcEqual2(c,c10100030.ritual_filter)
end
function c10100030.ritual_filter(c)
	return c:IsSetCard(0x322) and not c:IsCode(10100024) and not c:IsCode(10100025) and bit.band(c:GetType(),0x81)==0x81
end