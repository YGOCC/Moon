--Dimension Dragon Fate Rider
function c12000207.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000207,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12000207)
	e1:SetCondition(c12000207.sumcon)
	e1:SetTarget(c12000207.sumtg)
	e1:SetOperation(c12000207.sumop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000207,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,12000307)
	e2:SetCondition(c12000207.descon)
	e2:SetTarget(c12000207.destg)
	e2:SetOperation(c12000207.desop)
	c:RegisterEffect(e2)
end
function c12000207.cfilter1(c)
	return c:IsFaceup() and c:IsCode(12000207)
end
function c12000207.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x855)
end
function c12000207.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000207.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c12000207.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c12000207.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.IsPlayerCanSpecialSummonMonster(tp,12000208,0,0x4011,500,500,1,RACE_DRAGON,ATTRIBUTE_FIRE) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12000207.excfilter(c)
	return not c:IsCode(12000208)
end
function c12000207.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,12000208)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
	--all other monsters cannot be tributed for the tribute summon
	local exclude=Duel.GetMatchingGroup(c12000207.excfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local exc=exclude:GetFirst()
	while exc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		exc:RegisterEffect(e1)
		exc=exclude:GetNext()
	end
	--------
	Duel.Summon(tp,c,true,nil)
end
function c12000207.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c12000207.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12000207.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
