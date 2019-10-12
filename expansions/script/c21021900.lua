--Shishio
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.scost)
	e1:SetTarget(cid.stg)
	e1:SetOperation(cid.sop)
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
function cid.srfilter(c)
	return c:IsSetCard(0x219) and c:IsAbleToHand()
end
function cid.lfilter(c)
	return c:IsSetCard(0x219) and c:IsType(TYPE_LINK)
end
function cid.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function cid.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cid.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cid.srfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()==0 then return end
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
	if Duel.IsExistingMatchingCard(cid.lfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		if Duel.SelectYesNo(tp,aux.Stringid(2190,1)) then
			local ac1=Duel.AnnounceCard(tp)
			Duel.SetTargetParam(ac1)
			Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
			Duel.SetChainLimit(aux.FALSE)
			local ac2=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
			e:GetHandler():SetHint(CHINT_CARD,ac)
			--forbidden
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_FORBIDDEN)
			e1:SetTargetRange(0,0x7f)
			e1:SetTarget(cid.bantg)
			e1:SetLabel(ac2)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x219,0x219,1000,800,1,RACE_BEASTWARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x219,0x219,1000,800,1,RACE_BEASTWARRIOR,ATTRIBUTE_LIGHT) then
        c:AddMonsterAttribute(TYPE_NORMAL)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
    --    c:AddMonsterAttributeComplete(c)
        Duel.SpecialSummonComplete()
    end
end