--Number C300: Universal-Eyes Divine Lord Creation Dragon
function c88880015.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),9,5)
	--(1) immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	--(2) Win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_OVERLAY)
	e4:SetOperation(c88880015.operation)
	c:RegisterEffect(e4)
end
function c88880015.check(g)
	local a1=false
	local a2=false
	local a3=false
	local a4=false
	local a5=false
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetCode()
		if code==88880010 then a1=true
		elseif code==88880011 then a2=true
		elseif code==88880012 then a3=true
		elseif code==88880013 then a4=true
		elseif code==88880014 then a5=true
		end
		tc=g:GetNext()
	end
	return a1 and a2 and a3 and a4 and a5
end
function c88880015.operation(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_UNIVERSALEYES = 0x10
	local g1=Duel.GetFieldGroup(tp,LOCATION_OVERLAY,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_OVERLAY)
	local wtp=c88880015.check(g1)
	local wntp=c88880015.check(g2)
	if wtp and not wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Win(tp,WIN_REASON_UNIVERSALEYES)
	elseif not wtp and wntp then
		Duel.ConfirmCards(tp,g2)
		Duel.Win(1-tp,WIN_REASON_UNIVERSALEYES)
	elseif wtp and wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		Duel.Win(PLAYER_NONE,WIN_REASON_UNIVERSALEYES)
	end
end
