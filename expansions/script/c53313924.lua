--Mysterious Tornado Dragon
function c53313924.initial_effect(c)
	--fusion material: 1 "Mysterious" Dragon Monster + 1 WIND Winged Beast Monster.
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c53313924.matfilter1),aux.FilterBoolFunction(c53313924.matfilter2),true)
	--When this card is Summoned: Return all Spell/Trap cards on the field to their owner's Hands.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetTarget(c53313924.destg)
	e1:SetOperation(c53313924.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Once per turn: You can Tribute 1 monster you control: Banish 1 monster your opponent controls.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCost(c53313924.rmcost)
	e3:SetTarget(c53313924.rmtg)
	e3:SetOperation(c53313924.rmop)
	c:RegisterEffect(e3)
	--Once per turn: You can Banish 1 monster from your GY or Face-up in your Extra Deck; This card gains that monster's effects, also it gains ATK and DEF equal to its level/rank x100, these changes last until the end phase.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c53313924.cost)
	e4:SetOperation(c53313924.copy)
	c:RegisterEffect(e4)
end
function c53313924.matfilter1(c)
	return c:IsSetCard(0xCF6) and c:IsRace(RACE_DRAGON)
end
function c53313924.matfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST)
end
function c53313924.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c53313924.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c53313924.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsControler,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsControler,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c53313924.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c53313924.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if e:GetHandler():IsHasEffect(53313927) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if g:GetCount()>1 then Duel.GetFieldCard(tp,LOCATION_SZONE,5):RegisterFlagEffect(53313927,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end
	end
end
function c53313924.rfilter(c)
	return (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c53313924.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53313924.rfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c53313924.rfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c53313924.copy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() then
		c:CopyEffect(tc:GetCode(),RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		local lv=0
		if tc:GetLevel()>0 then lv=tc:GetLevel() end
		if tc:GetRank()>0 then lv=tc:GetRank() end
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e5:SetValue(lv*100)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e6)
	end
end
