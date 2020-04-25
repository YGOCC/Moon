 --Created and coded by Rising Phoenix
function c100000890.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode4(c,100000881,100000882,100000883,100000884,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
		--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000890,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100000890.descost)
	e2:SetTarget(c100000890.destg)
	e2:SetOperation(c100000890.desop)
	c:RegisterEffect(e2)
end
function c100000890.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c100000890.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000890.costfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c100000890.costfilter,tp,LOCATION_SZONE,0,1,rt,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c100000890.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOGRAVE)
	local eg=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,ct,0,0)
end
function c100000890.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.SendtoGrave(rg,nil,REASON_EFFECT)
	end
end