--RUM－Delta Star
function c4104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c4104.target)
	e1:SetOperation(c4104.activate)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4104,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c4104.rcon)
	e1:SetOperation(c4104.rop)
	c:RegisterEffect(e1)
end
function c4104.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10041036) and c:IsCanBeXyzMaterial(c)
end
function c4104.filter2(c)
	return c:IsSetCard(0x1004101D) and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(c)
end
function c4104.filter3(c,e,tp)
	return c:IsSetCard(0x1004) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c4104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c4104.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c4104.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c4104.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c4104.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c4104.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c4104.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4104.filter3,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c4104.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST+REASON_EFFECT)~=0 and re:IsHasType(0x7e0)
		and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x10041036)
		and e:GetHandler():IsAbleToRemoveAsCost()
		and ep==e:GetOwnerPlayer() and ev==1
end
function c4104.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
