--created & coded by Lyris
--機光襲雷竜－ビッグバン
function c240100030.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSpatialProc(c,4,true,aux.FilterBoolFunction(Card.IsSetCard,0x7c4),aux.FilterBoolFunction(Card.IsSetCard,0x7c4))
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_DESTROY)
	ae1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae1:SetCondition(c240100030.descon)
	ae1:SetOperation(c240100030.desop)
	c:RegisterEffect(ae1)
	local ae3=Effect.CreateEffect(c)
	ae3:SetDescription(aux.Stringid(240100435,0))
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_QUICK_O)
	ae3:SetCode(EVENT_FREE_CHAIN)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCondition(c240100030.con)
	ae3:SetCost(c240100030.nktg)
	ae3:SetTarget(c240100030.rmtg)
	ae3:SetOperation(c240100030.rmop)
	c:RegisterEffect(ae3)
	local ae5=Effect.CreateEffect(c)
	ae5:SetDescription(aux.Stringid(240100435,1))
	ae5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	ae5:SetType(EFFECT_TYPE_QUICK_O)
	ae5:SetCode(EVENT_FREE_CHAIN)
	ae5:SetRange(LOCATION_MZONE)
	ae5:SetCondition(c240100030.con)
	ae5:SetCost(c240100030.cost)
	ae5:SetTarget(c240100030.rttg)
	ae5:SetOperation(c240100030.rtop)
	c:RegisterEffect(ae5)
end
function c240100030.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c240100030.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7c4) and c:IsAbleToRemoveAsCost()
end
function c240100030.nktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c240100030.dfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c240100030.dfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c240100030.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c240100030.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFirstTarget()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and g:IsRelateToEffect(e) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c240100030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c240100030.dfilter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c240100030.dfilter,tp,LOCATION_GRAVE,0,5,8,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c240100030.cfilter(c)
	return not (c:IsSetCard(0x7c4) and c:IsType(TYPE_MONSTER))
end
function c240100030.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100030.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(c240100030.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	if e:GetLabel()==8 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c240100030.rtop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c240100030.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	if e:GetLabel()==8 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c240100030.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100030.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
