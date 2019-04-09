--CREATION Nova Xyz Seducer
function c88880031.initial_effect(c)
	--Pandemonium Effects
	--(p0) Pandemoium Summon
	aux.AddOrigPandemoniumType(c)
	aux.EnablePandemoniumAttribute(c)
	--(p1) You can only Pandemonium summon "CREATION" monsters. This Effect cannot be negated.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetRange(LOCATION_SZONE)
	ep1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ep1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	ep1:SetTargetRange(1,0)
	ep1:SetTarget(c39605510.splimit)
	c:RegisterEffect(ep1)
	--(p2) Once per turn, Special Summon 1 "CREATION" monster from your GY.
	local ep2=Effect.CreateEffect(c)
	ep2:SetType(EFFECT_TYPE_QUICK_O)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_SZONE)
	ep2:SetCountLimit(1)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCondition(aux.PandActCheck)
	ep2:SetTarget(c88880031.target)
	ep2:SetOperation(c88880031.operation)
	c:RegisterEffect(ep2)
	--(p3) Once per turn, you can target "CREATION" monsters on the field with the same level; Special Summon, from your Extra Deck, 1 "CREATION" Xyz monster whose Rank is equal to the level of the targeted monsters, using the targeted monsters as material. (This Special Summon is treated as an Xyz Summon.)
	local ep3=Effect.CreateEffect(c)
	ep3:SetType(EFFECT_TYPE_QUICK_O)
	ep3:SetCode(EVENT_FREE_CHAIN)
	ep3:SetRange(LOCATION_SZONE)
	ep3:SetCountLimit(1)
	ep3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep3:SetCondition(aux.PandActCheck)
	ep3:SetTarget(c88880031.xyztg)
	ep3:SetOperation(c88880031.xyzop)
	c:RegisterEffect(ep3)
	--Monster Effects
	--(1)
end
--(p1) You can only Pandemonium summon "CREATION" monsters. This Effect cannot be negated.
function c39605510.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSetCard(0x889)
end
--(p2) Once per turn, Special Summon 1 "CREATION" monster from your GY.
function c88880031.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x889)
end
function c88880031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c88880031.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88880031.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88880031.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88880031.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(p3)Once per turn, you can target "CREATION" monsters on the field with the same level; Special Summon, from your Extra Deck, 1 "CREATION" Xyz monster whose Rank is equal to the level of the targeted monsters, using the targeted monsters as material. (This Special Summon is treated as an Xyz Summon.)
function c88880031.filter1(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c88880031.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c88880031.spfilter1(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x889) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c88880031.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	e:SetLabel(lv)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c88880031.filter1(chkc,e,tp,lv) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c88880031.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.GetMatchingGroup(c88880031.filter1,tp,LOCATION_MZONE,0,e:GetHandler(),e,tp,lv)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,#g,nil)
		Duel.SetTargetCard(sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88880031.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local rk=e:GetLabel()
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCountFromEx(tp)<=0 or #mg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88880031.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end