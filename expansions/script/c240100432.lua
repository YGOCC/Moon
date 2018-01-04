--Astral Dragon of Stellar VINE
c240100432.spt_another_space=240100435
function c240100432.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	--1 monster + 1 monster with lower ATK (max. 600)
	aux.AddSpatialProc(c,nil,8,600,nil,aux.TRUE,aux.TRUE)
end
