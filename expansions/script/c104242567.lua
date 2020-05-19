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
	--destroy
	local ponyignition=Effect.CreateEffect(c)
	ponyignition:SetDescription(aux.Stringid(id,0))
	ponyignition:SetCategory(CATEGORY_DESTROY)
	ponyignition:SetType(EFFECT_TYPE_IGNITION)
	ponyignition:SetRange(LOCATION_MZONE)
	ponyignition:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ponyignition:SetCode(EVENT_FREE_CHAIN)
	ponyignition:SetCountLimit(1,id+1000)
	ponyignition:SetTarget(cid.sttg)
	ponyignition:SetOperation(cid.stop)
	c:RegisterEffect(ponyignition)
	local ponygy=ponyignition:Clone()
	ponygy:SetRange(LOCATION_GRAVE)
	ponygy:SetCost(cid.tdcost)
	c:RegisterEffect(ponygy)
end
--Filters
function cid.selfsummonfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function cid.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
--Send S/T to GY
function cid.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cid.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(cid.stfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cid.stfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cid.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
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
			Card.Type(tc,TYPE_PENDULUM+TYPE_MONSTER+TYPE_EFFECT) 
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
	if Card.Type then
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e) 
		then Duel.SendtoDeck(c,nil,-2,REASON_EFFECT) Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end	
			else
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e) 
		then Duel.Exile(c,REASON_EFFECT+REASON_RULE) Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end	
end
end