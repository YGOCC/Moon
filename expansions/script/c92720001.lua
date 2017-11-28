--Chronowitch Empress
function c92720001.initial_effect(c)
	c:EnableCounterPermit(0x2)
	c:SetCounterLimit(0x2,3)
	--place counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92720001,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c92720001.addcon)
	e1:SetOperation(c92720001.addc)
	c:RegisterEffect(e1)
	--attackup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c92720001.attackup)
    c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92720001,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,92720001)
	e3:SetCondition(c92720001.spcon)
	e3:SetCost(c92720001.spcost)
	e3:SetTarget(c92720001.sptg)
	e3:SetOperation(c92720001.spop)
	c:RegisterEffect(e3)
end
function c92720001.attackup(e,c)
    return c:GetCounter(0x2)*300
end
function c92720001.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)<3
end
function c92720001.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x2,1)
	end
end
function c92720001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)>=2
end
function c92720001.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c92720001.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(92720001)
end
function c92720001.filter(c,e,tp)
	return c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c92720001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.IsPlayerAffectedByEffect(tp,92720007) and Duel.IsExistingMatchingCard(c92720001.spfilter,tp,0,LOCATION_ONFIELD,1,nil)) or e:GetHandler():IsAbleToDeckAsCost() end
    if not e:GetHandler():IsAbleToDeckAsCost() or (Duel.IsPlayerAffectedByEffect(tp,92720007) 
	and Duel.IsExistingMatchingCard(c92720001.spfilter,tp,0,LOCATION_ONFIELD,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(92720001,0))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.SelectMatchingCard(tp,c92720001.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
        Duel.SendtoDeck(g,nil,2,REASON_COST)
    else
        Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
    end
end
function c92720001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c92720001.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92720001.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c92720001.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
		local g=Duel.SelectTarget(tp,c92720001.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c92720001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.GetFirstTarget()
	local tc1=Duel.SelectMatchingCard(tp,c92720001.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if tc and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP) and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end