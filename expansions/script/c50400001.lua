--Cyber Dancer
function c50400001.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50400001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50400001)
	e1:SetCondition(c50400001.spcon)
	e1:SetTarget(c50400001.sptg)
	e1:SetOperation(c50400001.spop)
	c:RegisterEffect(e1)
	--Name Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50400001,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c50400001.nametg)
	e2:SetOperation(c50400001.nameop)
	c:RegisterEffect(e2)
end
function c50400001.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c50400001.spcon(e,tp,eg,ep,ev,re,r,rp)
    return  Duel.IsExistingMatchingCard(c50400001.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c50400001.filter(c,e,tp)
	return c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR) and c:GetCode()~=50400001 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50400001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50400001.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION+HAND)
end
function c50400001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50400001.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50400001.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ac=0
	local ok=0
	while ac==0 and ok==0 do
		local ac=Duel.AnnounceCard(tp)
		if ac==97023549 or ac==11460577 then
			ok=1
			e:SetLabel(ac)
		else
			ac=0
		end
	end
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c50400001.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end