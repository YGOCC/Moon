--Viravolve Keylogger
function c221812202.initial_effect(c)
	--If a "Viravolve" monster is Special Summoned, except "Viravolve Keylogger": You can Special Summon this card from your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c221812202.spcon)
	e1:SetTarget(c221812202.sptg)
	e1:SetOperation(c221812202.spop)
	c:RegisterEffect(e1)
	--If this card is sent from the field to the GY, or detached from an Xyz Monster, inflict 200 damage to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c221812202.thcon)
	e2:SetOperation(c221812202.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_OVERLAY) and not c:IsReason(REASON_RULE) end)
	c:RegisterEffect(e3)
end
function c221812202.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa67) and not c:IsCode(221812202)
end
function c221812202.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c221812202.cfilter,1,nil)
end
function c221812202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c221812202.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c221812202.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetPreviousLocation()
	return (bit.band and bit.band(loc,LOCATION_ONFIELD)~=0) or loc&LOCATION_ONFIELD~=0 or (loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE))
end
function c221812202.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,221812202)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
