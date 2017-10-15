--Zero Revival
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,s_id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.IsExistingMatchingCard(scard.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,scard.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function scard.filter(c,e,tp)
	return c:IsSetCard(0xded) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function scard.sfilter(c)
	return c:GetLevel()==7 and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local sc=Duel.SelectMatchingCard(tp,scard.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(sc,REASON_EFFECT)
	end
end