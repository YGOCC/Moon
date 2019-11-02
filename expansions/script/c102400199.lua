--created & coded by Lyris, art
--フェイツ出会い
local cid,id=GetID()
function cid.initial_effect(c)
	local getRitLevel=Card.GetRitualLevel
	Card.GetRitualLevel=function(tc,rc)
		if tc:IsLocation(LOCATION_SZONE) then
			local lv,t=tc:GetOriginalLevel(),{tc:IsHasEffect(EFFECT_RITUAL_LEVEL)}
			if #t>0 then lv=t[#t]:GetValue()(t[#t],rc) end
			return lv
		else return getRitLevel(tc,rc) end
	end
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
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(function(e,tp) return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 end)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
end
function cid.spfilter(c,e,tp,mc1,mc2)
	local trap=c:IsLocation(LOCATION_SZONE)
	return c:IsSetCard(0xf7a) and (bit.band(c:GetType(),0x81)==0x81 or trap) and (not c.mat_filter or c.mat_filter(mc,tp))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,trap,true)
		and mc1:IsCanBeRitualMaterial(c) and mc2:IsCanBeRitualMaterial(c)
end
function cid.rfilter(c,mc1,mc2)
	local mlv=mc1:GetRitualLevel(c)+mc2:GetRitualLevel(c)
	if mlv==mc1:GetLevel()+mc2:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv>=bit.band(mlv,0xffff) or lv>=bit.rshift(mlv,16)
end
function cid.filter(c,e,tp,mg)
	return mg:IsExists(cid.filter2,1,nil,e,tp,c)
end
function cid.levelf(c)
	return c:IsLocation(LOCATION_SZONE) and c:GetOriginalLevel() or c:GetLevel()
end
function cid.filter2(c,e,tp,mc)
	if (c:IsLevelAbove(1) and mc:IsLevelAbove(1)) or (not c:IsLevelAbove(1) and not mc:IsLevelAbove(1)) then return false end
	local i1,i2
	if c:GetLevel()>0 then i1,i2=c:GetLevel(),Duel.ReadCard(mc,CARDDATA_LEVEL)
	else i1,i2=Duel.ReadCard(c,CARDDATA_LEVEL),mc:GetLevel() end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,c,e,tp,c,mc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,id) then ft=1 end
	return sg:IsExists(cid.rfilter,1,nil,c,mc) or sg:CheckWithSumGreater(cid.levelf,i1+i2,1,ft)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil)
		return mg:IsExists(cid.filter,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
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
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,mc,e,tp,mc,mc2)
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,id) then ft=1 end
	local b1=sg:IsExists(cid.rfilter,1,nil,mc,mc2)
	local i1,i2
	if mc:GetLevel()>0 then i1,i2=mc:GetLevel(),Duel.ReadCard(mc2,CARDDATA_LEVEL)
	else i1,i2=Duel.ReadCard(mc,CARDDATA_LEVEL),mc2:GetLevel() end
	local b2=sg:CheckWithSumGreater(cid.levelf,i1+i2,1,ft)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,cid.rfilter,1,1,nil,mc,mc2)
		local tc=tg:GetFirst()
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumGreater(tp,cid.levelf,i1+i2,1,ft)
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		tc=tg:GetFirst()
		while tc do
			local trap=tc:IsLocation(LOCATION_SZONE)
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,trap,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function cid.thfilter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
function cid.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cid.thfilter2),tp,LOCATION_GRAVE,0,nil)
		if #mg>0 and Duel.SelectYesNo(tp,1190) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
