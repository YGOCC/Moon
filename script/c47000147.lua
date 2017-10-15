--Digimon Aquan Surface
function c47000147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c47000147.sptg)
	e1:SetOperation(c47000147.spop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetCondition(c47000147.actcon)
	c:RegisterEffect(e2)
end
function c47000147.filter(c,e,sp)
	return c:IsSetCard(0x2FBA) and c:IsType(TYPE_SPELL) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function c47000147.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c47000147.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c47000147.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47000147.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47000147.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c47000147.filter2(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(4) and c:IsRace(RACE_SEASERPENT)
end
function c47000147.actcon(e)
	return Duel.IsExistingMatchingCard(c47000147.filter2,tp,LOCATION_MZONE,0,1,nil)
end
