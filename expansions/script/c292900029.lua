--Ventus of Termina ???
--[]
function c292900029.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(292900029,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,292900029)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c292900029.sptg)
	e1:SetOperation(c292900029.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(292900029,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c292900029.negcon)
	e2:SetCost(c292900029.negcost)
	e2:SetTarget(c292900029.negtg)
	e2:SetOperation(c292900029.negop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(292900029,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c292900029.descon)
	e3:SetTarget(c292900029.destg)
	e3:SetOperation(c292900029.desop)
	c:RegisterEffect(e3)
end
--Special Summon
function c292900029.desfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xb56) or c:IsSetCard(0x12c))
end
function c292900029.desfilter2(c,e)
	return c292900029.desfilter(c) and c:IsCanBeEffectTarget(e)
end
function c292900029.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c292900029.desfilter(chkc) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if chk==0 then return ct<=3 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.IsExistingTarget(c292900029.desfilter,tp,LOCATION_ONFIELD,0,3,nil)
		and (ct<=0 or Duel.IsExistingTarget(c292900029.desfilter,tp,LOCATION_MZONE,0,ct,nil)) end
	local g=nil
	if ct>0 then
		local tg=Duel.GetMatchingGroup(c292900029.desfilter2,tp,LOCATION_ONFIELD,0,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=tg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<3 then
			tg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=tg:Select(tp,3-ct,3-ct,nil)
			g:Merge(g2)
		end
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,c292900029.desfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c292900029.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		--Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
			c:CompleteProcedure()
		end
	end
end
--function c94656263.spop(e,tp,eg,ep,ev,re,r,rp)
--	local c=e:GetHandler()
--	if not c:IsRelateToEffect(e) then return end
--	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
--		c:CompleteProcedure()
	--end
--end
--Negate
function c292900029.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
--	end
end
--function c292900029.desfilter(c)
--	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND)
--end
function c292900029.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(292900029)==0 end
	c:RegisterFlagEffect(292900029,RESET_CHAIN,0,1)
end
function c292900029.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if chk==0 then return c:IsDestructable() end--and g:GetCount()>0 end
   -- if chk==0 then return Duel.IsExistingMatchingCard(c292900029.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
   -- Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
   --c:RegisterFlagEffect(292900029,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	--c:RegisterFlagEffect(292900029,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		--c:RegisterFlagEffect(292900029,RESET_CHAIN,0,1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c292900029.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	--local g1=Duel.SelectMatchingCard(tp,c292900029.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
	--if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			--c:RegisterFlagEffect(292900029,RESET_CHAIN,0,1)
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
--Destroy
function c292900029.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK)
end
function c292900029.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c292900029.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end