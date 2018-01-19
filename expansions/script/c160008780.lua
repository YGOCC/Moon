--Medivatale Tinker Bell
function c160008780.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,160008780)
	e1:SetCondition(c160008780.sprcon)
	c:RegisterEffect(e1)
--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160008780,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,160008781)
	e2:SetCondition(c160008780.spcon)
	e2:SetTarget(c160008780.sptg)
	e2:SetOperation(c160008780.spop)
	c:RegisterEffect(e2)
--gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c160008780.mtcon)
	e3:SetOperation(c160008780.mtop)
	c:RegisterEffect(e3)
end
function c160008780.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xab5) or c:IsCode(160008780)
end
function c160008780.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c160008780.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c160008780.xxxfilter(c)
	return c:IsFaceup() and  c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT)
end
function c160008780.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c160008780.xxxfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c160008780.spfilter(c,e,tp)
	return  c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY) and not c:IsCode(160008780) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c160008780.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160008780.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c160008780.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160008780.spfilter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c160008780.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c160008780.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return  ec:GetMaterial():IsExists(c160008780.ffilter,1,nil) and r==REASON_MATERIAL+0x10000000
end
function c160008780.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,160008780)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(160008780,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c160008780.atkcon)
	e1:SetTarget(c160008780.atktg)
	e1:SetOperation(c160008780.atkop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c160008780.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+388)
end
function c160008780.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xab5)
end
function c160008780.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c160008780.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(Card.Isable,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c160008780.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
	 Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
