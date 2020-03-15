--created by NeverThisAgain, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(cid.rtg)
	e2:SetOperation(cid.rop)
	c:RegisterEffect(e2)
end
function cid.mfilter(c,e,tp,chk)
	local f=cid.filter
	if chk~=0 then f=aux.NecroValleyFilter(f) end
	return c:IsFaceup() and c:IsSetCard(0x50b) and c:IsType(TYPE_FUSION)
		and c:GetSummonLocation()==LOCATION_EXTRA
		and Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp,c)
end
function cid.filter(c,e,tp,mc)
	local g=Group.FromCards(mc)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and c:GetType()&0x81==0x81 and c:IsSetCard(0x50b)
		and mc:IsCanBeRitualMaterial(c)
		and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.mfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectMatchingCard(tp,cid.mfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,1)
	local mc=mg:GetFirst()
	if not mc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mc)
	local tc=sg:GetFirst()
	if tc then
		tc:SetMaterial(mg)
		Duel.ReleaseRitualMaterial(mg)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cid.rfilter(c)
	return c:GetType()&0x81==0x81 and c:IsAbleToDeck()
end
function cid.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cid.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cid.rop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(tp)
	local c=e:GetHandler()
	if c:IsAbleToHand() and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
