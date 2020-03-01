--Etherveil Reversion
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
                c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cid.actcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cid.spcon)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)

	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(cid.sdcon)
	c:RegisterEffect(e3)

	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(cid.rmtg)
	e6:SetOperation(cid.rmop)
	c:RegisterEffect(e6)
end
function cid.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x312)
end
function cid.spcfilter(c,tp)
	return (c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_GRAVE) or c:IsPreviousLocation(LOCATION_EXTRA)) and c:IsPosition(POS_FACEDOWN)
end
function cid.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cid.sdcon(e)
	return not Duel.IsExistingMatchingCard(cid.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cid.cfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckAsCost()
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	local g=Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_REMOVED,0,5,nil) 
	if g then
	                 local sg=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_REMOVED,0,5,5,e:GetHandler())
	                 Duel.SendtoDeck(sg,nil,5,REASON_COST)
		 res=true
	end
	if not res and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cid.spcfilter,1,nil,tp)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
