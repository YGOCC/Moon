 --Created and coded by Rising Phoenix
function c100000746.initial_effect(c)
aux.AddEquipProcedure(c,0,c100000746.filtere)
	--Atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c100000746.value)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c100000746.value)
	c:RegisterEffect(e3)
end
function c100000746.filtere(c)
	return c:IsFaceup() and c:IsSetCard(0x118) and c:IsType(TYPE_MONSTER)
end
function c100000746.filt(c)
	return c:IsSetCard(0x118) and c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c100000746.value(e,c)
	return Duel.GetMatchingGroupCount(c100000746.filt,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*500
end