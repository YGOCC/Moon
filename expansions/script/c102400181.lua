--created & coded by Lyris
--フェイツ・ネクロガイ
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(function(e,tp) return not Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil) end)
	e3:SetCountLimit(1,id)
	e3:SetCost(cid.cost)
	c:RegisterEffect(e3)
end
function cid.cfilter(c)
	return c:GetSequence()<5
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil),1,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetCondition(cid.retcon)
			e1:SetOperation(function(te) Duel.ReturnToField(te:GetLabelObject()) end)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cid.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
