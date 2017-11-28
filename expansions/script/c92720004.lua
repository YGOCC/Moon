--Chronowitch of Justice
function c92720004.initial_effect(c)
	c:EnableCounterPermit(0x2)
	c:SetCounterLimit(0x2,3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c92720004.spcon)
	e1:SetOperation(c92720004.spop)
	c:RegisterEffect(e1)
	--place counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92720004,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c92720004.addcon)
	e2:SetOperation(c92720004.addc)
	c:RegisterEffect(e2)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c92720004.attackup)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(92720004,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,92720004)
	e4:SetCondition(c92720004.descon)
	e4:SetCost(c92720004.descost)
	e4:SetTarget(c92720004.destg)
	e4:SetOperation(c92720004.desop)
	c:RegisterEffect(e4)
end
function c92720004.attackup(e,c)
	return c:GetCounter(0x2)*1100
end
function c92720004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x2,3,REASON_COST)
end
function c92720004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x2,3,REASON_RULE)
end
function c92720004.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)<3
end
function c92720004.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x2,1)
	end
end
function c92720004.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)>=3
end
function c92720004.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c92720004.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(92720004)
end
function c92720004.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsPlayerAffectedByEffect(tp,92720007) and Duel.IsExistingMatchingCard(c92720004.spfilter,tp,0,LOCATION_ONFIELD,1,nil)) or e:GetHandler():IsAbleToDeckAsCost() end
	if not e:GetHandler():IsAbleToDeckAsCost() or (Duel.IsPlayerAffectedByEffect(tp,92720007) 
	and Duel.IsExistingMatchingCard(c92720004.spfilter,tp,0,LOCATION_ONFIELD,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(92720004,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c92720004.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	else
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	end
end
function c92720004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92720004.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92720004.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c92720004.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	end
end
