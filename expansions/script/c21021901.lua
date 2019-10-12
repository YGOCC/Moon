--Momiji
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.bcost)
	e1:SetTarget(cid.btg)
	e1:SetOperation(cid.bop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1000)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
end
function cid.sfilter(c)
	return c:IsSetCard(0x219) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cid.bfilter(c)
	return c:IsSetCard(0x219) and c:IsAbleToRemove()
end
function cid.drfilter(c)
	return c:IsSetCard(0x219) and c:IsAbleToDeck()
end
function cid.lfilter(c)
	return c:IsSetCard(0x219) and c:IsType(TYPE_LINK)
end
function cid.bcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cid.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.bfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cid.bop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.bfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cid.lfilter,tp,LOCATION_MZONE,0,1,nil) then
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cid.drfilter,tp,LOCATION_GRAVE,0,3,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(2190,0)) then
				Duel.BreakEffect()
				local g=Duel.SelectTarget(tp,cid.drfilter,tp,LOCATION_GRAVE,0,3,3,nil)
				Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
				Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
				local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if tg:GetCount()<=0 then return end
				Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
				local g1=Duel.GetOperatedGroup()
				if g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
				local ct=g1:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
				if ct>0 then
					Duel.BreakEffect()
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x219,0x219,1000,800,2,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x219,0x219,1000,800,2,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then
        c:AddMonsterAttribute(TYPE_NORMAL)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
    --    c:AddMonsterAttributeComplete(c)
        Duel.SpecialSummonComplete()
    end
end