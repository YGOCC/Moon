--Sonic Cosmo'n
function c81455790.initial_effect(c)
	--spsumon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(81455790)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81455790.spcon)
	e1:SetTarget(c81455790.sptg)
	e1:SetOperation(c81455790.spop)
	c:RegisterEffect(e1)
	if not c81455790.global_check then
		c81455790.global_check=true
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c81455790.operation)
		Duel.RegisterEffect(ge1,0)
	end
end
function c81455790.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
end
function c81455790.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(584)>0 then val=c:GetFlagEffectLabel(584) end
	return c:IsControler(tp) and c:IsSetCode(0xCF11) and c:GetLevel()~=val
end
function c81455790.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81455790.cfilter,1,nil,tp)
end
function c81455790.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81455790.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end