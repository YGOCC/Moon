-- Ultimate Evolzaur Dolkka
local card = c77700001
function card.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--2 monsters with different Types
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(240100001,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(card.linkcon)
	e0:SetOperation(card.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77700001)
	e1:SetTarget(card.sptg)
	e1:SetOperation(card.spop)
	c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,77700002)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(card.cost)
	e2:SetTarget(card.sumtg)
	e2:SetOperation(card.sumop)
	c:RegisterEffect(e2)

end
function card.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function card.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,card.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,card.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function card.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(card.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function card.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,card.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
			Duel.SpecialSummon(g,170,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local rf=g:GetFirst().evolreg
		if rf then rf(g:GetFirst()) end
	end
end
function card.spfilter(c,e,tp)
	return c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,170,tp,false,false)
end

function card.filter(c,e,tp,zone)
	return c:IsRace(RACE_REPTILE) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and card.filter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(card.filter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,card.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function card.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	if tc and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function card.linkfilter1(c,lc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE) and c:IsCanBeLinkMaterial(lc) and Duel.IsExistingMatchingCard(card.linkfilter2,tp,LOCATION_MZONE,0,1,c,lc,c,tp)
end
function card.linkfilter2(c,lc,mc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_DINOSAUR)) and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function card.linkcon(e,c)
	if c==nil then return true end
	if (c:IsType(TYPE_PENDULUM) or (not Card.IsTypeCustom or c:IsTypeCustom("Pandemonium") or c:IsTypeCustom("Relay"))) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(card.linkfilter1,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function card.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,card.linkfilter1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,card.linkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end


