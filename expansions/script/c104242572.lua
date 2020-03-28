--Moon's Dream: You're Gone!
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
 	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.cost)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.destg)
	e1:SetOperation(cid.desop)
	c:RegisterEffect(e1)
	--Fragment creation
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(cid.fragcon)
	e2:SetTarget(cid.fragtg)
	e2:SetOperation(cid.fragop)
	c:RegisterEffect(e2)
end


function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44335251,2))
	if chk==0 then return Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) end
	local tc=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_COST)
	end
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cid.fragcon(e,tp,eg,ep,ev,re,r,rp)
	return  tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
function cid.fragtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cid.fragop(e,tp,eg,ep,ev,re,r,rp,chk)		
	--	local sc=Duel.CreateToken(tp,104242585)
	--	sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
	--	Duel.SendtoExtraP(sc,tp,REASON_RULE)
	    local c=e:GetHandler()
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end
end

