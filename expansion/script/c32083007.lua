--32083007
function c32083007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c32083007.refcon)
	c:RegisterEffect(e1)
		--spsummon
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c32083007.negcon)
	e2:SetTarget(c32083007.cttg)
	e2:SetOperation(c32083007.ctop)
	c:RegisterEffect(e2)
end
function c32083007.refcon(e,re,val,r,rp,rc)
	if e:GetHandler():GetPreviousLocation()~=LOCATION_REMOVED then return end
	return bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetHandler():GetControler()
end
function c32083007.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and ep~=tp
end
function c32083007.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32083007.ctop(e,tp,eg,ep,ev,re,r,rp)
Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
