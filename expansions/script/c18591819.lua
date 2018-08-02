--REPLACEMENT OF ASSASSINS
function c18591819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x50e))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18591819,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c18591819.condition)
	e3:SetTarget(c18591819.target)
	e3:SetOperation(c18591819.operation)
	c:RegisterEffect(e3)
end
function c18591819.condition(e,tp,eg,ep,ev,re,r,rp)
	local lv=0
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_DESTROY) and tc:IsSetCard(0x50e) and not tc:IsPreviousLocation(LOCATION_SZONE) then
			local tlv=tc:GetLevel()
			if tlv>lv then lv=tlv end
		end
		tc=eg:GetNext()
	end
	if lv>0 then e:SetLabel(lv) end
	return lv>0
end
function c18591819.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x50e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18591819.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18591819.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c18591819.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18591819.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
