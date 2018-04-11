--created & coded by Lyris, art from Chaotic's "Oiponts Claws"
--集いし襲雷
function c240100037.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,240100037+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(c240100037.target)
	e0:SetOperation(c240100037.activate)
	c:RegisterEffect(e0)
end
function c240100037.filter0(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeFusionMaterial() and c:IsDestructable()
end
function c240100037.filter1(c,e)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeFusionMaterial() and c:IsDestructable() and not c:IsImmuneToEffect(e)
end
function c240100037.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsRace(RACE_DRAGON)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c240100037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg=Group.CreateGroup()
		local mg1=Duel.GetMatchingGroup(c240100037.filter0,tp,LOCATION_DECK,0,nil)
		for tc in aux.Next(mg1) do
			mg:AddCard(tc)
			mg1:Remove(Card.IsCode,tc,tc:GetCode())
		end
		return Duel.IsExistingMatchingCard(c240100037.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c240100037.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg=Duel.GetMatchingGroup(c240100037.filter1,tp,LOCATION_DECK,0,nil,e)
	local mg1=Group.CreateGroup()
	for tc in aux.Next(mg) do
		mg1:AddCard(tc)
		mg:Remove(Card.IsCode,tc,tc:GetCode())
	end
	local sg1=Duel.GetMatchingGroup(c240100037.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	if sg1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		tc:SetMaterial(mat1)
		Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
