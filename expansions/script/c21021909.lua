-- Jurogumo
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Summon from Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.bcost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
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
function cid.lfilter(c)
	return c:IsSetCard(0x219) and c:IsType(TYPE_LINK)
end
function cid.spfilter1(c,e,tp)
	return c:IsSetCard(0x219) and c:IsType(TYPE_SPELL+TYPE_NORMAL)
		and Duel.IsExistingMatchingCard(cid.spfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c:GetLevel())
end
function cid.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0x219) and c:IsType(TYPE_SPELL+TYPE_NORMAL) and not c:IsLevel(lv) and c:IsLevelAbove(0)
end
function cid.bcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0x219) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(cid.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cid.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		local g2=Duel.SelectMatchingCard(tp,cid.spfilter2,tp,LOCATION_MZONE,0,1,1,g1,e,tp,tc:GetLevel())
		g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_EFFECT)==2 then
			local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
	if Duel.IsExistingMatchingCard(cid.lfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		local g3=Duel.GetMatchingGroup(cid.rmfilter,tp,0,LOCATION_EXTRA,nil)
		if g3:GetCount()>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(2190,8)) then
				local tc1=g3:RandomSelect(tp,1):GetFirst()
				Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function cid.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x219,0x219,1000,800,9,RACE_INSECT,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x219,0x219,1000,800,9,RACE_INSECT,ATTRIBUTE_LIGHT) then
        c:AddMonsterAttribute(TYPE_NORMAL)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
    --    c:AddMonsterAttributeComplete(c)
        Duel.SpecialSummonComplete()
    end
end