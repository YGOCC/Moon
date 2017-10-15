--Coded-Eyes Renegade Dragon
function c1020030.initial_effect(c)
	Auxiliary.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xded),2,true)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1020030,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1020030.con)
	e1:SetTarget(c1020030.tg)
	e1:SetOperation(c1020030.op)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1020030,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1020030.descon)
	e2:SetTarget(c1020030.destg)
	e2:SetOperation(c1020030.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end
function c1020030.con(e)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION
end
function c1020030.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2ded)
end
function c1020030.ctfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1ded)
end
function c1020030.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsLocation(LOCATION_SZONE)
end
function c1020030.desfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c1020030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c1020030.ctfilter,tp,LOCATION_MZONE,0,nil)
		local ct1=Duel.GetMatchingGroupCount(c1020030.ctfilter1,tp,LOCATION_MZONE,0,nil)
		local sel=0
		if ct>0 and Duel.IsExistingMatchingCard(c1020030.desfilter,tp,0,LOCATION_ONFIELD,1,nil) then sel=sel+1 end
		if ct1>0 and Duel.IsExistingMatchingCard(c1020030.desfilter1,tp,0,LOCATION_MZONE,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1020030,0))
		sel=Duel.SelectOption(tp,aux.Stringid(1020030,1),aux.Stringid(1020030,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(1020030,1))
	else
		Duel.SelectOption(tp,aux.Stringid(1020030,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.GetMatchingGroup(c1020030.desfilter,tp,0,LOCATION_SZONE,nil)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		local g=Duel.GetMatchingGroup(c1020030.desfilter1,tp,0,LOCATION_MZONE,nil)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c1020030.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local ct=Duel.GetMatchingGroupCount(c1020030.ctfilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(c1020030.desfilter,tp,0,LOCATION_SZONE,nil)
		if ct>0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	else
		local ct=Duel.GetMatchingGroupCount(c1020030.ctfilter1,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(c1020030.desfilter1,tp,0,LOCATION_MZONE,nil)
		if ct>0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c1020030.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c1020030.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xded)
end
function c1020030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c1020030.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,g:GetCount()*300,0,0)
end
function c1020030.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1020030.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Damage(1-tp,g:GetCount()*300,REASON_EFFECT)
end
