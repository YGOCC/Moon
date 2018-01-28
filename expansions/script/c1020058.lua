--Bushido Burning Drake
--Script by XGlitchy30
function c1020058.initial_effect(c)
	--normal summon event
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1020058)
	e1:SetCondition(c1020058.spcon)
	e1:SetTarget(c1020058.sptg)
	e1:SetOperation(c1020058.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1020158)
	e2:SetCondition(c1020058.spscon)
	e2:SetTarget(c1020058.spstg)
	e2:SetOperation(c1020058.spsop)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,10200258)
	e3:SetCondition(c1020058.rccon)
	e3:SetTarget(c1020058.rctg)
	e3:SetOperation(c1020058.rcop)
	c:RegisterEffect(e3)
end
--filters
function c1020058.ncheck(c)
	return c:IsFaceup() and c:IsSetCard(0x4b0)
end
function c1020058.spcheck(c)
	return c:IsFaceup() and c:IsSetCard(0x4b0) and ((not c:IsType(TYPE_XYZ) and c:GetLevel()<=4) or (c:IsType(TYPE_XYZ) and c:GetRank()<=4))
end
function c1020058.rccheck(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x4b0) and (c:GetLevel()>=5 or c:GetRank()>=5) and c:GetSummonPlayer()==tp
end
--normal summon event
function c1020058.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(c1020058.ncheck,1,nil)
end
function c1020058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1020058.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--spsummon
function c1020058.spscon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and g:IsExists(c1020058.spcheck,1,nil)
end
function c1020058.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1020058.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c1020058.spscon(e,tp,eg,ep,ev,re,r,rp,0) then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
--recyle
function c1020058.rccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1020058.rccheck,1,nil,tp)
end
function c1020058.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c1020058.rcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end