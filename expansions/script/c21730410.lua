--A.O. Timestride
--By Auramram
local s,id=GetID()
function s.initial_effect(c)
	--activate (return)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--return
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x719)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
	local sg=g:FilterSelect(1-tp,Card.IsAbleToHand,ct,ct,nil,1-tp)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)<=0 then
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		end
	end
end
