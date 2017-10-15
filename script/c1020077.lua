--Hellscape Duke Wohzar
function c1020077.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c1020077.xyzfilter,4,4,c1020077.ovfilter,aux.Stringid(1020077,0))
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1020077,1))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1020077.sscon)
	e1:SetTarget(c1020077.sstg)
	e1:SetOperation(c1020077.ssop)
	e1:SetCountLimit(1,1020077+EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e1)
	--salvage
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(1020077,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c1020077.target)
	e2:SetOperation(c1020077.operation)
	e1:SetCountLimit(1,20077+EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG2_XMDETACH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11020077)
	e3:SetCost(c1020077.cost)
	e3:SetTarget(c1020077.postg)
	e3:SetOperation(c1020077.posop)
	c:RegisterEffect(e3)
end
function c1020077.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c1020077.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==4 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c1020077.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c1020077.spfilter(c,e,tp)
	return c:IsSetCard(2073) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1020077.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1020077.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1020077.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1020077.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1020077.filter(c)
	return c:IsSetCard(2073) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1020077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c1020077.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1020077.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1020077.filter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c1020077.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoHand(sg,nil,REASON_EFFECT)
	if ct and ct>0 then
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
function c1020077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1020077.posfilter(c,pos)
	return c:GetPosition()~=pos
end
function c1020077.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c1020077.posfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetPosition()) end
end
function c1020077.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	local def=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	if c:IsAttackPos() and c:IsFaceup() and def:GetCount()>0 then
		local ct=Duel.ChangePosition(def,POS_FACEUP_ATTACK)
		if ct and ct>0 then
			--atkup
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(ct*100)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
	if c:IsDefensePos() and c:IsFaceup() and atk:GetCount()>0 then
		local ct=Duel.ChangePosition(atk,POS_FACEUP_DEFENSE)
		if ct and ct>0 then
			--atkup
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(ct*100)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end
