--created & coded by Lyris
--フェイツ出会い
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
end
function cid.spfilter(c,e,tp,mc1,mc2)
	return c:IsSetCard(0xf7a) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc,tp))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc1:IsCanBeRitualMaterial(c) and mc2:IsCanBeRitualMaterial(c)
end
function cid.filter(c,e,tp,mg)
	return mg:IsExists(cid.filter2,1,nil,e,tp,c)
end
function cid.filter2(c,e,tp,mc)
	if (c:IsLevelAbove(1) and mc:IsLevelAbove(1)) or (not c:IsLevelAbove(1) and not mc:IsLevelAbove(1))
		or c:IsType(TYPE_LINK) or mc:IsType(TYPE_LINK) then return false end
	local i1,i2
	if c:GetLevel()>0 then i1,i2=c:GetLevel(),Duel.ReadCard(mc,CARDDATA_LEVEL)
	else i1,i2=Duel.ReadCard(c,CARDDATA_LEVEL),mc:GetLevel() end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_HAND,0,c,e,tp,c,mc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	return sg:CheckWithSumGreater(Card.GetLevel,i1+i2,1,ft)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil)
		return mg:IsExists(cid.filter,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,cid.filter,1,1,nil,e,tp,mg)
	local mc=mat:GetFirst()
	if not mc then return end
	local mc2=mg:FilterSelect(tp,cid.filter2,1,1,nil,e,tp,mc):GetFirst()
	mat:AddCard(mc2)
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_HAND,0,mc,e,tp,mc,mc2)
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local i1,i2
	if mc:GetLevel()>0 then i1,i2=mc:GetLevel(),Duel.ReadCard(mc2,CARDDATA_LEVEL)
	else i1,i2=Duel.ReadCard(mc,CARDDATA_LEVEL),mc2:GetLevel() end
	if sg:CheckWithSumGreater(Card.GetLevel,i1+i2,1,ft) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumGreater(tp,Card.GetLevel,i1+i2,1,ft)
		for tc in aux.Next(tg) do tc:SetMaterial(mat) end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		for tc in aux.Next(tg) do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
		Duel.SpecialSummonComplete()
	end
end
function cid.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local mg=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(mg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,mg)
end
