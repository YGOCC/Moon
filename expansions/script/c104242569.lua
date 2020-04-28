--Moon's Dream: Little Harbinger
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
	local ponysummon=Effect.CreateEffect(c)
	ponysummon:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ponysummon:SetType(EFFECT_TYPE_IGNITION)
	ponysummon:SetCode(EVENT_FREE_CHAIN)
	ponysummon:SetRange(LOCATION_HAND)
	ponysummon:SetCountLimit(1,id)
	ponysummon:SetTarget(cid.fragmenttg)	
	ponysummon:SetOperation(cid.fragment)
	c:RegisterEffect(ponysummon)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+1000)
	e1:SetCondition(cid.thcon)
	e1:SetTarget(cid.negtg)
	e1:SetOperation(cid.negop)
	c:RegisterEffect(e1)
	--gy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+2000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(cid.sfcost)
	e2:SetTarget(cid.sftg)
	e2:SetOperation(cid.sfop)
	c:RegisterEffect(e2)
end
--Filters
function cid.selfsummonfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function cid.shufflefilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsAbleToDeckAsCost()
end
function cid.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
--On grave, negate 1
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY) and  bit.band(r,REASON_COST)~=0)
	or
	(e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and  bit.band(r,REASON_COST+REASON_MATERIAL+REASON_BATTLE+REASON_EFFECT)~=0)
end
function cid.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cid.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,cid.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cid.negop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
--Pony summon proc
function cid.fragmenttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and cid.selfsummonfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.selfsummonfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cid.fragment(e,c,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cid.selfsummonfilter,tp,LOCATION_DECK,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,cid.selfsummonfilter,tp,LOCATION_DECK,0,1,1,c)
	if Card.Type then 
		local tc=g:GetFirst()
			Card.Type(tc,TYPE_PENDULUM) 
				Duel.RemoveCards(tc,nil,REASON_EFFECT+REASON_RULE)
					Duel.SendtoExtraP(tc,POS_FACEUP,REASON_RULE+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function() if not tc:IsLocation(LOCATION_EXTRA) then Card.Type(tc,TYPE_EFFECT+TYPE_MONSTER) Card.Race(tc,RACE_BEAST)  e1:Reset() e1:GetLabelObject():Reset() end end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	else
	local tc=g:GetFirst()
			tc:SetCardData(CARDDATA_TYPE,tc:GetType()+TYPE_PENDULUM)
				Duel.Exile(tc,REASON_EFFECT+REASON_RULE)
					Duel.SendtoExtraP(tc,POS_FACEUP,REASON_RULE+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function() if not tc:IsLocation(LOCATION_EXTRA) then tc:SetCardData(CARDDATA_TYPE,tc:GetType()-TYPE_PENDULUM) e1:Reset() e1:GetLabelObject():Reset() end end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	end
			local sc=Duel.CreateToken(tp,104242585)
				if Card.Type then 
					Card.Type(sc,TYPE_PENDULUM)
						Duel.Remove(sc,POS_FACEUP,REASON_COST) 
	else
					sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN) 
						Duel.Remove(sc,POS_FACEUP,REASON_COST+REASON_RULE)  
						end
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
end
end
--GY effect
function cid.sfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cid.shufflefilter,tp,LOCATION_GRAVE,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,cid.shufflefilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cid.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cid.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,cid.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cid.sfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  then
		local g=Group.FromCards(c,tc)
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
end