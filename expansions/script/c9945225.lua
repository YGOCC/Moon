function c9945225.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--UnTarg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945225,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c9945225.cost)
	e2:SetCountLimit(1,9945225)
	e2:SetCondition(c9945225.condition)
	e2:SetOperation(c9945225.operation)
	c:RegisterEffect(e2)
	--Special
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9945225,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,9945226)
	e4:SetCost(c9945225.spcost)
	e4:SetOperation(c9945225.spop)
	c:RegisterEffect(e4)
	--Special 2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9945225,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,9945226)
	e5:SetCost(c9945225.spcost2)
	e5:SetOperation(c9945225.spop2)
	c:RegisterEffect(e5)
	--Indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,9945227)
	e6:SetCondition(c9945225.uncon)
	e6:SetValue(c9945225.indval)
	c:RegisterEffect(e6)
end
function c9945225.cfilter(c)
	return not c:IsSetCard(0x204F)
end
function c9945225.cfilter2(c)
	return not c:IsSetCard(0x2050)
end
function c9945225.cfilter3(c)
	return not c:IsSetCard(0x204F2050)
end
function c9945225.tgfilter(c)
	return c:IsSetCard(0x204F) and c:IsSetCard(0x2050)
end
function c9945225.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and not Duel.IsExistingMatchingCard(c9945225.cfilter2,tp,LOCATION_HAND,0,1,nil) or not Duel.IsExistingMatchingCard(c9945225.cfilter,tp,LOCATION_HAND,0,1,nil)
		or not Duel.IsExistingMatchingCard(c9945225.cfilter3,tp,LOCATION_HAND,0,1,nil)
end
function c9945225.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and not Duel.IsExistingMatchingCard(Card.IsPublic,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c9945225.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	--cannot be target
		if not Duel.IsExistingMatchingCard(c9945225.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c9945225.cfilter3,tp,LOCATION_HAND,0,1,nil) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9945225,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)	
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2050))
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9945225,4))
	elseif not Duel.IsExistingMatchingCard(c9945225.cfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c9945225.cfilter3,tp,LOCATION_HAND,0,1,nil) then
		--cannot be target
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(9945225,5))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_FZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x204F))
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e2)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9945225,5))
	elseif not Duel.IsExistingMatchingCard(c9945225.cfilter3,tp,LOCATION_HAND,0,1,nil) then
		--cannot be target
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(9945225,6))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(aux.TargetBoolFunction(c9945225.tgfilter))
		e3:SetValue(aux.tgoval)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e3)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9945225,6))
	end
end
function c9945225.spfilter(c)
	return c:IsSetCard(0x204F) and c:IsDiscardable()
end
function c9945225.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945225.spfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9945225.spfilter2(c)
	return c:IsSetCard(0x2050) and c:IsDiscardable()
end
function c9945225.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945225.spfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9945225.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9945225,4))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCondition(c9945225.tgcon)
		e1:SetTarget(c9945225.tgtg2)
		e1:SetOperation(c9945225.tgop2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
end
function c9945225.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9945225,5))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCondition(c9945225.tgcon)
		e1:SetTarget(c9945225.tgtg)
		e1:SetOperation(c9945225.tgop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
end
function c9945225.tgfilter(c,e,tp)
	return c:IsSetCard(0x204F) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945225.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9945225.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9945225.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c9945225.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsDestructable() then
	e:SetCategory(CATEGORY_DESTROY)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	elseif Duel.IsExistingMatchingCard(c9945225.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9945225.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9945225.tgfilter2(c,e,tp)
	return c:IsSetCard(0x2050) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945225.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9945225.tgop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c9945225.tgfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsDestructable() then
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	elseif Duel.IsExistingMatchingCard(c9945225.tgfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9945225.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9945225.unfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x204F) or c:IsSetCard(0x2050)
end
function c9945225.uncon(e)
	return Duel.IsExistingMatchingCard(c9945225.unfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9945225.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end