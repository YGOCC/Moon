--Spell-Disciple Magnetism Mage
function c249000624.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000624.condition)
	e1:SetCost(c249000624.cost)
	e1:SetTarget(c249000624.target)
	e1:SetOperation(c249000624.operation)
	c:RegisterEffect(e1)
	if not c249000624.global_check then
		c249000624.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(249000624)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end
function c249000624.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(249000624)>0
end
function c249000624.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c249000624.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000624.resolvefilter(c)
	return c:IsSetCard(0x1D9) and c:IsType(TYPE_MONSTER)
end
function c249000624.revealfilter(c)
	return c:IsSetCard(0x1D9) and not c:IsPublic()
end
function c249000624.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsExistingMatchingCard(c249000624.resolvefilter,tp,LOCATION_GRAVE,0,1,nil) then
	elseif Duel.IsExistingMatchingCard(c249000624.revealfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g2=Duel.SelectMatchingCard(tp,c249000624.revealfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g2)
		Duel.ShuffleHand(tp)
	else return end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	if dc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,2) then
		Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
	end
end