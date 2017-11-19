--Rank-Up-Magic - The Cursed Swordsmaster
function c240100258.initial_effect(c)
	--Target 1 LIGHT Warrior-Type Xyz Monster you control; Special Summon from your Extra Deck, 1 DARK Warrior-Type monster that is 1 Rank higher than that target by using that target as the material. (This Special Summon is treated as an Xyz Summon. Transfer its materials to this card.)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c240100258.target)
	e1:SetOperation(c240100258.activate)
	c:RegisterEffect(e1)
	--(Quick Effect): You can banish this card from your GY, then target 1 DARK Warrior-Type Xyz Monster you control; detach 1 material from a monster your opponent controls and attach it to that monster you control as a material.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c240100258.mattg)
	e2:SetOperation(c240100258.matop)
	c:RegisterEffect(e2)
end
function c240100258.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and c:IsRace(RACE_WARRIOR)
		and Duel.IsExistingMatchingCard(c240100258.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c240100258.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c240100258.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c240100258.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c240100258.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c240100258.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c240100258.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c240100258.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c240100258.xyzfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR)
end
function c240100258.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c240100258.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c240100258.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetOverlayCount(tp,0,1)~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c240100258.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c240100258.matop(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstTarget()
	if not sc:IsRelateToEffect(e) or sc:IsControler(1-tp) then return end
	local g1=Duel.GetOverlayGroup(tp,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(240100258,0))
	local mg2=g1:Select(tp,1,1,nil)
	local oc=mg2:GetFirst():GetOverlayTarget()
	Duel.Overlay(sc,mg2)
	Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
end
