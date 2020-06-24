--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetTarget(cid.rmtg)
	e1:SetOperation(cid.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.settg)
	e2:SetOperation(cid.setop)
	c:RegisterEffect(e2)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6c97,0x9c97) and c:IsAbleToRemove()
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.SelectTarget(tp,cid.filter,tp,LOCATION_MZONE,0,1,1,nil),1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(Card.IsAbleToRemove,nil)
	if not tc:IsRelateToEffect(e) or Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)==0
		or not tc:IsLocation(LOCATION_REMOVED) or #tg==0 then return end
	Duel.BreakEffect()
	Duel.Remove(tg:RandomSelect(tp,1),POS_FACEDOWN,REASON_EFFECT)
end
function cid.cfilter(c)
	return c:IsSetCard(0xc97) and c:IsAbleToRemoveAsCost()
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	Duel.Remove(Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil),POS_FACEUP,REASON_COST)
end
function cid.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
end
function cid.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
