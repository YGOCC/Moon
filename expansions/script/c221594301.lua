--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.xtg)
	e1:SetOperation(cid.xop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(1166)
	e2:SetTarget(cid.ltg)
	e2:SetOperation(cid.lop)
	c:RegisterEffect(e2)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function cid.xfilter1(c)
	return c:IsLevel(4) and c:IsSetCard(0xc97)
end
function cid.xfilter2(c,e,tp)
	local mc=e:GetHandler()
	return c:IsRank(4) and c:IsSetCard(0xc97) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.IsExistingMatchingCard(cid.xfilter1,tp,LOCATION_HAND,0,1,mc)
end
function cid.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.xfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
end
function cid.xop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.xfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=Duel.SelectMatchingCard(tp,cid.xfilter1,tp,LOCATION_HAND,0,1,1,c)
		if #og>0 then
			Duel.BreakEffect()
			Duel.Overlay(sc,og+c)
		end
	end
end
function cid.lfilter1(c,lc)
	return c:IsSetCard(0xc97) and c:IsAbleToRemove() and c:IsCanBeLinkMaterial(lc)
end
function cid.lfilter2(c,e,tp)
	local mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return c:IsSetCard(0xc97) and c:IsType(TYPE_LINK)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and mg:IsExists(cid.lfilter1,c:GetLink()-1,e:GetHandler(),c) and aux.MustMaterialCheck(mg,tp,EFFECT_MUST_BE_LMATERIAL)
end
function cid.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.lfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.lop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToRemove()or Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.lfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,cid.lfilter1,tp,LOCATION_HAND,0,sc:GetLink()-1,sc:GetLink()-1,c,sc)+c
		sc:SetMaterial(tc)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
