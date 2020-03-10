local cid,id=GetID()
--Roman Keys - XXVII
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--Must first be Fusion Summoned with a "Roman Keys" card effect.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--While Fusion Summoning this card, gain LP equal to the ATK of all monsters on the field.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetCost(aux.TRUE)
	e5:SetOperation(cid.costop)
	c:RegisterEffect(e5)
	--This card can attack while in face-up Defense Position. If it does, apply its DEF for damage calculation.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cid.costop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetSum(Card.GetAttack),REASON_EFFECT)
end
