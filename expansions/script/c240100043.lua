--created & coded by Lyris
--襲雷の召喚儀式
function c240100043.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c240100043.condition)
	e1:SetTarget(c240100043.target)
	e1:SetOperation(c240100043.activate)
	c:RegisterEffect(e1)
end
function c240100043.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c240100043.cfilter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsDestructable()
		and Duel.IsExistingMatchingCard(c240100043.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c240100043.filter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsSetCard(0x7c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100043.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c240100043.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c240100043.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c240100043.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c240100043.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c240100043.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
		local sc=g:GetFirst()
		if sc and Duel.SpecialSummonStep(g,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()
		end
	end
end
