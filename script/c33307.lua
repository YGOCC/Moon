--Girl Of The Skies: Artemis
function c33307.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()

--pop
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33307)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCondition(c33307.condition)
	e1:SetCost(c33307.cost)
	e1:SetTarget(c33307.target)
	e1:SetOperation(c33307.activate)
	c:RegisterEffect(e1)

--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c33307.indval)
	c:RegisterEffect(e3)

--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function c33307.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33307.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c33307.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

function c33307.cfilter(c)
	return c:IsFaceup() and c:IsCode(3330)
end

function c33307.costfilter(c)
	return c:IsFaceup() and c:IsCode(3330)
end
function c33307.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33307.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c33307.costfilter,tp,LOCATION_MZONE,0,1,5,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	e:SetLabel(ct)
end
function c33307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,e:GetLabel(),tp,LOCATION_MZONE)
end
function c33307.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetLabel(ct),nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
end
end
