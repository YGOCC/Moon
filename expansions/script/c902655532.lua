--Pandemoniumgraph of Eternity
function c902655532.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
	--Other "Pandemoniumgraph" cards you control cannot targeted by your opponent's Spell/Trap effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(function(e,c) return c:IsSetCard(0xcf80) and c~=e:GetHandler() end)
	e2:SetValue(c902655532.evalue)
	c:RegisterEffect(e2)
	--When you Pandemonium Summon a monster(s) using a "Pandemoniumgraph" card: You can draw 1 card.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCondition(c902655532.indcon)
	e3:SetTarget(c902655532.indtg)
	e3:SetOperation(c902655532.indop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_EXTRA,0)
	e4:SetLabelObject(e3)
	e4:SetCost(aux.TRUE)
	e4:SetOperation(c902655532.check)
	c:RegisterEffect(e4)
	--You can only control 1 "Pandemoniumgraph of Eternity".
	c:SetUniqueOnField(1,0,902655532)
end
function c902655532.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=e:GetHandlerPlayer()
end
function c902655532.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_SPECIAL+726)
end
function c902655532.indcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c902655532.cfilter,1,nil,tp)
		and e:GetLabelObject():IsSetCard(0xcf80)
end
function c902655532.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c902655532.indop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c902655532.pafilter(c)
	return aux.PaCheckFilter(c)
		and c:GetTurnID()==Duel.GetTurnCount() and c:GetReason()==REASON_RULE+REASON_RELEASE
end
function c902655532.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c902655532.pafilter,tp,LOCATION_EXTRA,0,nil)
	e:GetLabelObject():SetLabelObject(tc)
end
