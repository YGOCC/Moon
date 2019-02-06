--created & coded by Lyris
--ハートブレイカー・ドラゴン
function c210400089.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c210400089.spcon)
	e1:SetTarget(c210400089.sptg)
	e1:SetOperation(c210400089.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c210400089.negcon)
	e2:SetTarget(c210400089.negtg)
	e2:SetOperation(c210400089.negop)
	c:RegisterEffect(e2)
end
function c210400089.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c210400089.spcon(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if Duel.IsExistingMatchingCard(c210400089.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg,tc:GetPreviousCodeOnField()) then return true end
	end
	return false
end
function c210400089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c210400089.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
	end
end
function c210400089.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c210400089.negtg(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c210400089.filter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c210400089.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local c=e:GetHandler()
	local ct=0
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if not tc:IsDisabled() then ct=ct+1 end
	end
	local tg=g:Filter(c210400089.filter,nil)
	if ct>0 and tg:GetCount()>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(210400089,0)) then
		Duel.BreakEffect()
		Duel.ChangePosition(tg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
	end
end
