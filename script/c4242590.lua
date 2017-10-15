--Lunar Phase: Moon Burst United
function c4242590.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x666),1)
	c:EnableReviveLimit()
	--add synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c4242590.sptg)
	e0:SetOperation(c4242590.spop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242590,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c4242590.thcon)
	e1:SetTarget(c4242590.thtg)
	e1:SetOperation(c4242590.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242590,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,4242590)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c4242590.condition)
	e2:SetCost(c4242590.cost)
	e2:SetOperation(c4242590.operation)
	c:RegisterEffect(e2)

end
function c4242590.spfilter1(c)
	if Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsCode,4242564),tp,LOCATION_EXTRA,0,nil)>1 then
		return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsFaceup()
			and Duel.IsExistingMatchingCard(c4242590.spfilter2,tp,LOCATION_EXTRA,0,1,c,c:GetLevel())
	else
		return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToGraveAsCost() and not c:IsCode(4242564)
			and Duel.IsExistingMatchingCard(c4242590.spfilter2,tp,LOCATION_EXTRA,0,1,c,c:GetLevel())
	end
end
function c4242590.spfilter2(c,lv)
	if Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsCode,4242564),tp,LOCATION_EXTRA,0,nil)>1 then
		return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:GetLevel()~=lv
			and c:IsAbleToGraveAsCost() and c:IsFaceup()
	else
		return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:GetLevel()~=lv and not c:IsCode(4242564)
			and c:IsAbleToGraveAsCost() and c:IsFaceup()
	end
end
function c4242590.spfilter3(c)
	return c:IsCode(4242564) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c4242590.sptg(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4242590.spfilter1,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(c4242590.spfilter3,tp,LOCATION_EXTRA,0,1,nil)
end
function c4242590.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c4242590.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c4242590.spfilter2,tp,LOCATION_EXTRA,0,1,1,tc,tc:GetLevel())
		local g3=Duel.SelectMatchingCard(tp,c4242590.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil)
		g1:Merge(g2)
		g1:Merge(g3)
		Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	end
end
function c4242590.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c4242590.filter(c)
	return c:GetCode()==4242578 and c:IsAbleToHand()
end
function c4242590.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c4242590.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4242590.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c4242590.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c4242590.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c4242590.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
