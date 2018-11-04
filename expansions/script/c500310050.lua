--Sweethard Mika Rodent
function c500310050.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c500310050.spcon)
	c:RegisterEffect(e1)
			--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500310050,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,500310050)
	e2:SetCondition(c500310050.spcon2)
	e2:SetTarget(c500310050.sptg2)
	e2:SetOperation(c500310050.spop2)
	c:RegisterEffect(e2)
end
function c500310050.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa34) and c:GetCode()~=500310050
end
function c500310050.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c500310050.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c500310050.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousTypeOnField(),TYPE_EVOLUTE)~=0
		and c:IsPreviousSetCard(0xa34) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c500310050.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500310050.cfilter,1,nil,tp,rp)
end
function c500310050.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c500310050.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end