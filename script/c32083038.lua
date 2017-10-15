--Dimensional Twilight
function c32083038.initial_effect(c)
--XYZ SUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32083038,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c32083038.target)
	e1:SetOperation(c32083038.activate)
	c:RegisterEffect(e1)
--SYNCHRO SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32083038,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c32083038.synchroactivate)
	c:RegisterEffect(e2)
end
function c32083038.filter(c,e)
	return c:IsSetCard(0x7D53) and c:IsCanBeEffectTarget(e)
end
function c32083038.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function c32083038.mfilter1(c,mg,exg)
	return mg:IsExists(c32083038.mfilter2,1,c,c,exg)
end
function c32083038.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c32083038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c32083038.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local exg=Duel.GetMatchingGroup(c32083038.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and exg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=mg:FilterSelect(tp,c32083038.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=mg:FilterSelect(tp,c32083038.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32083038.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c32083038.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c32083038.tfilter,nil,e)
	if g:GetCount()<2 then return end
	local xyzg=Duel.GetMatchingGroup(c32083038.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c32083038.filter11(c,e,tp)
	if c:IsType(TYPE_TUNER) and c:IsSetCard(0x7D53) and c:IsAbleToRemoveAsCost() then
		local mg=Duel.GetMatchingGroup(c32083038.filter12,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c32083038.filter13,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),mg)
	else return false end
end
function c32083038.filter12(c)
	return c:IsAbleToRemoveAsCost() and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x7D53) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function c32083038.filter13(c,e,tp,lv,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x7D53) and c:IsLevelBelow(30) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and mg:CheckWithSumEqual(Card.GetOriginalLevel,c:GetLevel()-lv,1,63,c)
end
function c32083038.spfil1(c,e,tp)
	if c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x7D53) and c:IsLevelBelow(30) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) then
		return Duel.IsExistingMatchingCard(c32083038.spfil2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
	else return false end
end
function c32083038.spfil2(c,tp,sc)
	if c:IsType(TYPE_TUNER) and c:IsSetCard(0x7D53) and c:IsAbleToRemoveAsCost() then
		local mg=Duel.GetMatchingGroup(c32083038.filter12,tp,LOCATION_GRAVE,0,nil)
		--return Duel.IsExistingMatchingCard(c32083038.spfil3,tp,LOCATION_EXTRA,0,1,nil,sc:GetLevel()-c:GetLevel(),mg,sc)
		return mg:IsExists(c32083038.spfil3,1,nil,sc:GetLevel()-c:GetLevel(),mg,sc)
	else return false end
end
function c32083038.spfil3(c,limlv,mg,sc)
	local fg=mg:Clone()
	fg:RemoveCard(c)
	--Debug.Message("Difference: " .. mg:GetCount() .. "/" .. fg:GetCount())
	local newlim=limlv-c:GetLevel()
	--Debug.Message("Code: "  .. c:GetCode() .. ", new level = " .. newlim)
	--return newlim==0 or mg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc)
	if newlim==0 then return true else return fg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc) end
end
function c32083038.synchroactivate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c32083038.filter11,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		--local g1=Duel.SelectMatchingCard(tp,c32083038.filter11,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		--local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local exg=Duel.SelectMatchingCard(tp,c32083038.spfil1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local ex=exg:GetFirst()
		local tglv=ex:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c32083038.spfil2,tp,LOCATION_GRAVE,0,1,1,nil,tp,ex)
		local lv=g1:GetFirst():GetLevel()
		local mg2=Duel.GetMatchingGroup(c32083038.filter12,tp,LOCATION_GRAVE,0,nil)
		while lv<tglv do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=mg2:FilterSelect(tp,c32083038.spfil3,1,1,nil,tglv-lv,mg2,ex)
			local gc=g2:GetFirst()
			lv=lv+gc:GetLevel()
			mg2:RemoveCard(gc)
			g1:AddCard(gc)
		end
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT+REASON_COST)
		Duel.SpecialSummon(ex,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		ex:CompleteProcedure()
	end
end