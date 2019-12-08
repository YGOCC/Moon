--Moon's Dream, React!
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--special summon
	local exx=Effect.CreateEffect(c)
	exx:SetCategory(CATEGORY_TOHAND)
	exx:SetType(EFFECT_TYPE_IGNITION)
	exx:SetRange(LOCATION_GRAVE)
	exx:SetCondition(cid.spcon2)
	exx:SetTarget(cid.thtg)
	exx:SetOperation(cid.thop)
	c:RegisterEffect(exx)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cid.rmtg)
	e1:SetOperation(cid.rmop)
	c:RegisterEffect(e1)
end
--Banish till chain end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(cid.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		--	Debug.Message(tc:GetCode())
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(cid.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cid.retop(e,tp,eg,ep,ev,re,r,rp)
  --  Debug.Message(string.format("My operation tc %s",e:GetLabelObject():GetCode()))
    Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
--recursion
function cid.spcfilter2(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.spcon2(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,2,nil)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
	if Duel.Exile(tc,REASON_RULE) then
	tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
	if Duel.Exile(tc,REASON_RULE) then
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	end
	end
end
end
end