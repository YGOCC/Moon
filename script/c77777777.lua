--Honor Cross Dragon
function c77777777.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,c77777777.synfilter,aux.NonTuner(c77777777.synfilter2),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c77777777.tglimit)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c77777777.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--Destroy Zombie and DARK
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c77777777.cost)
	e3:SetTarget(c77777777.target)
	e3:SetOperation(c77777777.operation)
	c:RegisterEffect(e3)
end
function c77777777.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c77777777.synfilter2(c)
	return c:IsRace(RACE_WARRIOR)
end
function c77777777.tglimit(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_ZOMBIE)
end
function c77777777.disable(e,c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT and c:IsRace(RACE_ZOMBIE) or c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c77777777.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD,nil)
end
function c77777777.filter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsFaceup() and c:IsDestructable() or c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup() and c:IsDestructable()
end
function c77777777.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777777.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c77777777.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77777777.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77777777.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end