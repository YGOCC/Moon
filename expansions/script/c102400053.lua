--created & coded by Lyris, art from Shadowverse's "Acceleratium"
--滅却スペースシップ
local cid,id=GetID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCategory(CATEGORY_DESTROY)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5cd))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cid.destg)
	e5:SetOperation(cid.desop)
	c:RegisterEffect(e5)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function cid.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),tp)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		Duel.BreakEffect()
		if Duel.Destroy(dg,nil,REASON_EFFECT)==0 then return end
		local p=dg:GetFirst():GetPreviousControler()
		local sg=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_ONFIELD,0,nil,0x5cd)
		for tc in aux.Next(sg) do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(tc:GetLocation()&LOCATION_ONFIELD)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetLabel(p)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(cid.efilter)
			tc:RegisterEffect(e2)
		end
	end
end
function cid.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetLabel() and te:GetOwner()~=e:GetOwner()
end
