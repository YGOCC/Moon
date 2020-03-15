--created by Meedogh, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
end
function cid.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsDestructable() and c:IsSetCard(0xcf11) and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_EXTRA,0,1,c,c,e,tp)
end
function cid.filter(c,mc,e,tp)
	return c:IsType(TYPE_BIGBANG) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_BIGBANG,tp,false,false)
		and aux.IsCodeListed(c,mc:GetOriginalCode())
		and mc:IsCanBeBigBangMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc)>0
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Destroy(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_EXTRA,0,1,g,g:GetFirst(),e,tp)
	if #sg>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_BIGBANG,tp,tp,false,false,POS_FACEUP)
	end
end
