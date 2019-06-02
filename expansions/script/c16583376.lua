--Signore Antilementale Ocenere
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	c:EnableReviveLimit()
	--pandemonium effect
	local p1=Effect.CreateEffect(c)
	p1:SetDescription(aux.Stringid(id,0))
	p1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	p1:SetType(EFFECT_TYPE_QUICK_O)
	p1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	p1:SetCode(EVENT_FREE_CHAIN)
	p1:SetRange(LOCATION_SZONE)
	p1:SetCountLimit(1,id)
	p1:SetCondition(aux.PandActCheck)
	p1:SetCost(cid.thcost)
	p1:SetTarget(cid.thtg)
	p1:SetOperation(cid.thop)
	c:RegisterEffect(p1)
	aux.EnablePandemoniumAttribute(c,p1)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.sprcon)
	e1:SetOperation(cid.sprop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(cid.drycost)
	e2:SetTarget(cid.drytg)
	e2:SetOperation(cid.dryop)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id+200)
	e3:SetCondition(cid.rccon)
	e3:SetTarget(cid.rctg)
	e3:SetOperation(cid.rcop)
	c:RegisterEffect(e3)
end
--filters
function cid.chkfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa6e) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(cid.rmfilter,tp,LOCATION_DECK,0,1,nil,tp,c:GetAttribute())
end
function cid.rmfilter(c,tp,attr)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(attr) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_REMOVED,0,1,nil,c:GetAttribute())
end
function cid.thfilter(c,attr)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetAttribute()~=attr and c:IsAbleToHand()
end
function cid.sprfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_AQUA) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cid.sprfilter1,tp,LOCATION_MZONE,0,1,c,tp,c)
end
function cid.sprfilter1(c,tp,exc)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cid.sprfilter2,tp,LOCATION_MZONE,0,1,c,exc,c:GetAttribute())
end
function cid.sprfilter2(c,exc,attr)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:GetAttribute()~=attr and c~=exc
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function cid.rcfilter(c,attr)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa6e) and c:GetAttribute()~=attr and c:IsAbleToHand()
end
--pandemonium effect
function cid.thcost(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.GetFlagEffect(tp,id)<=0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cid.chkfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cid.chkfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cid.chkfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cid.rmfilter,tp,LOCATION_DECK,0,1,1,nil,tp,tc:GetAttribute())
		if #g>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
				local attr=Duel.GetOperatedGroup():GetFirst():GetAttribute()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,attr)
				if #g2>0 then
					Duel.SendtoHand(g2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g2)
				end
			end
		end
	end
end
--spsummon proc
function cid.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(cid.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cid.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cid.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local exc=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,cid.sprfilter1,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,exc)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,cid.sprfilter2,tp,LOCATION_MZONE,0,1,1,g2:GetFirst(),exc,g1:GetFirst():GetAttribute())
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
--destroy
function cid.drycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cid.drytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil)
		return #g>0 and not g:IsExists(aux.NOT(Card.IsAbleToRemoveAsCost),1,nil) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og<=0 then return end
		local ct=og:GetClassCount(Card.GetPreviousAttributeOnField)
		if ct>0 then
			e:SetLabel(ct)
		end
	end
	if e:GetLabel()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cid.dryop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--recycle
function cid.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cid.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cid.rcfilter(chkc,e:GetHandler():GetAttribute()) end
	if chk==0 then return Duel.IsExistingTarget(cid.rcfilter,tp,LOCATION_REMOVED,0,1,nil,e:GetHandler():GetAttribute()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cid.rcfilter,tp,LOCATION_REMOVED,0,1,1,nil,e:GetHandler():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cid.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end