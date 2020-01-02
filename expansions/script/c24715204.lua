--created by manu, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cid.handcon)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCondition(function(e,tp,eg,ep,ev) return Duel.IsChainNegatable(ev) end)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.handcon(e)
	return Duel.GetMatchingGroupCount(aux.NOT(Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x70b)==0
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)~=0 end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsSetCard(0x70b) and tc:GetOwner()==tp and Duel.NegateActivation(ev)
		and re:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(eg,REASON_EFFECT)
	elseif tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
