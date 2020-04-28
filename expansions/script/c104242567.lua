--Moon's Dream, The Helpful Pony
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
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+1000)
	e1:SetCondition(cid.thcon)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
		--gy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+2000)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(cid.sftg)
	e2:SetOperation(cid.sfop)
	c:RegisterEffect(e2)

end
--Filters
function cid.selfsummonfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function cid.tohandfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cid.protfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--On grave, search S/T
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY) and  bit.band(r,REASON_COST)~=0)
	or
	(e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and  bit.band(r,REASON_COST+REASON_MATERIAL+REASON_BATTLE+REASON_EFFECT)~=0)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
	--Duel.SpecialSummonComplete()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.tohandfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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
function cid.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.protfilter(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingTarget(cid.protfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cid.protfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cid.sfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  then
		local g=Group.FromCards(c,tc)
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e2)
	end
end
end