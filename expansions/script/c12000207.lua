--Dimension Dragon Fate Rider
function c12000207.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000207,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12000207)
	e1:SetCondition(c12000207.sumcon1)
	e1:SetCost(c12000207.sumcost)
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
	--summon (quick)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12000207,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,12000207)
	e4:SetCondition(c12000207.sumcon2)
	e4:SetCost(c12000207.sumcost)
	e4:SetTarget(c12000207.sumtg)
	e4:SetOperation(c12000207.sumop)
	c:RegisterEffect(e4)
end
function c12000207.cfilter1(c)
	return c:IsFaceup() and c:IsCode(12000207)
end
function c12000207.cfilter2(c)
	return c:IsFaceup() and c:IsCode(12000210)
end
function c12000207.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000207.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c12000207.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000207.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000207.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c12000207.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000207.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c12000207.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000208,0,0x4011,500,500,1,RACE_DRAGON,ATTRIBUTE_FIRE) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and c:IsSummonable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c12000207.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token=Duel.CreateToken(tp,12000208)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.Summon(tp,c,true,nil,1)
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
