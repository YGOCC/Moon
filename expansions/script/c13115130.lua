--Nymfomania Healing Fruit
--Keddy was here~
local id,cod=13115130,c13115130
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cod.operation)
	c:RegisterEffect(e2)
	--Return to Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(cod.rttg)
	e3:SetOperation(cod.rtop)
	c:RegisterEffect(e3)
end
function cod.operation(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>1 then
		local ec=eg:GetFirst()
		local val=0
		if ec:IsSetCard(0x523) then
			val=val+200
			ec=eg:GetNext()
		end
		if val==0 then return end
		Duel.Recover(e:GetHandlerPlayer(),val,REASON_EFFECT)
	else
		local ec=eg:GetFirst()
		if ec:IsSetCard(0x523) then
			Duel.Recover(e:GetHandlerPlayer(),200,REASON_EFFECT)
		end
	end
end
function cod.rfilter(c,tid)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid and c:IsAbleToDeck()
end
function cod.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cod.rfilter(chkc,Duel.GetTurnCount()) end
	if chk==0 then return Duel.IsExistingTarget(cod.rfilter,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function cod.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cod.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end