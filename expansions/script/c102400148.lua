--created & coded by Lyris, art from Shadowverse's "Destruction in White"
--破びの白い天使
local cid,id=GetID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetTarget(cid.target)
	e0:SetOperation(cid.activate)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cid.acop)
	c:RegisterEffect(e2)
	c:SetUniqueOnField(1,0,id)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function cid.cfilter(c,tp)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetPreviousControler()==tp
end
function cid.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local ct=eg:Filter(cid.cfilter,nil,tp):GetMaxGroup(Card.GetTextAttack)
	if #ct>1 then ct=ct:RandomSelect(tp,1) end
	Duel.Recover(tp,ct:GetFirst():GetTextAttack(),REASON_EFFECT)
end
