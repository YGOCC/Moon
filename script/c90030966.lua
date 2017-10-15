--Carnal Desire LV4
function c90030966.initial_effect(c)
	c:SetSPSummonOnce(90030966)
	c:EnableCounterPermit(0x660)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90030966,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c90030966.descond)
	e1:SetTarget(c90030966.destg)
	e1:SetOperation(c90030966.desop)
	c:RegisterEffect(e1)
	--counter for damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_DAMAGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c90030966.addc)
    c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90030966,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c90030966.spcost)
	e3:SetTarget(c90030966.sptg)
	e3:SetOperation(c90030966.spop)
	c:RegisterEffect(e3)
	--double attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(90030966,2))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c90030966.atkcond)
	e4:SetCost(c90030966.atkcost)
	e4:SetTarget(c90030966.atktg)
	e4:SetOperation(c90030966.atkop)
	c:RegisterEffect(e4)
end
c90030966.lvupcount=1
c90030966.lvup={47880400}
c90030966.lvdncount=1
c90030966.lvdn={539193}
function c90030966.descond(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c90030966.retfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x660) and c:IsAbleToDeck()
end
function c90030966.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c90030966.retfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c90030966.retfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c90030966.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c90030966.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	if g1:GetFirst():IsRelateToEffect(e) and Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)~=0 then
		local tc=g2:GetFirst()
		if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)==1 then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
function c90030966.addc(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		e:GetHandler():AddCounter(0x660,2)
	end
end
function c90030966.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(0x660))
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c90030966.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv+3) and c:IsSetCard(0x660) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c90030966.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c90030966.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e:GetHandler():GetCounter(0x660),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c90030966.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90030966.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c90030966.atkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c90030966.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90030966.atkfilter(c)
	return c:IsFaceup() and c:IsCode(47880400)
end
function c90030966.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c90030966.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c90030966.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90030966.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90030966.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCondition(c90030966.rdcon)
		e2:SetOperation(c90030966.rdop)
		tc:RegisterEffect(e2)
	end
end
function c90030966.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c90030966.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end