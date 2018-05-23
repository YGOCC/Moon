--Mekbuster Navigator
--Keddy was here~
local function ID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
--Not Fully Scripted
local id,cod=ID()
function cod.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,cod.lmfilter,2,2)
	c:EnableReviveLimit()
	--SPLimit
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xff,0)
	e1:SetTarget(cod.frctg)
	e1:SetValue(cod.frcval)
	c:RegisterEffect(e1)]]--
	--Name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(67864641)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cod.spcost)
	e3:SetTarget(cod.sptg)
	e3:SetOperation(cod.spop)
	c:RegisterEffect(e3)
end
function cod.lmfilter(c)
	return c:IsLinkRace(RACE_MACHINE) or c:IsLinkSetCard(0x2a6)
end
function cod.frctg(e,c)
	return c:IsRace(RACE_MACHINE) or c:IsSetCard(0x2a6)
end
function cod.frcval(e,c,fp,rp,r)
	return e:GetHandler():GetLinkedZone()
end
function cod.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cod.spfilter(c,e,tp)
	return c:IsLevelAbove(6) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cod.sfilter(c,g)
	return g:IsContains(c) and c:IsAbleToGrave()
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cod.sfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler():GetLinkedGroup())
		and Duel.IsExistingMatchingCard(cod.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cod.sfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler():GetLinkedGroup())
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cod.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(e,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end