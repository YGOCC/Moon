--CREATION Planetary Survivor
function c88880028.initial_effect(c)
	--Pendulum Effects
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--(p1) You cannot Pendulum Summon monsters, except "CREATION" monsters.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ep1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	ep1:SetTargetRange(1,0)
	ep1:SetTarget(c88880028.splimit)
	c:RegisterEffect(ep1)
	--(p2) Once a turn, you can activate 1 "CREATION" Continuous spell directly from your deck. 
	local ep2=Effect.CreateEffect(c)
	ep2:SetDescription(aux.Stringid(88880028,1))
	ep2:SetCategory(CATEGORY_SEARCH)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetCountLimit(1)
	ep2:SetTarget(c88880028.thtg)
	ep2:SetOperation(c88880028.thop)
	c:RegisterEffect(ep2)
	--(p3) If you control a "Number 300" monster: you take no damage while this card is on the field.
	local ep3=Effect.CreateEffect(c)
	ep3:SetType(EFFECT_TYPE_FIELD)
	ep3:SetRange(LOCATION_PZONE)
	ep3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	ep3:SetCondition(c88880028.damcon)
	c:RegisterEffect(ep3)
	local ep4=ep3:Clone()
	ep4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(ep4)
	--Monster Effects
end
--Pendulum Effects
--(p1)
function c88880028.filter(c)
	return c:IsSetCard(0x889)
end
function c88880028.splimit(e,c,tp,sumtp,sumpos)
	if not (bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM) then return end
	return not c88880028.filter(c)
end
--(p2) Once a turn, you can activate 1 "CREATION" Continuous spell directly from your deck. 
function c88880028.thfilter(c,tp)
	return c:IsSetCard(0x889) and c:GetType()==0x20002
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c88880028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880028.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880028.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88880028,3))
	local g=Duel.SelectMatchingCard(tp,c88880028.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
--(p3) If you control a "Number 300" monster: you take no damage while this card is on the field.
function c88880028.cfilter(c)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no and no==300 and c:IsSetCard(0x48) and c:IsType(TYPE_MONSTER)
end
function c88880028.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88880028.cfilter,tp,LOCATION_FIELD,0,1,nil)
end
--Monster Effects