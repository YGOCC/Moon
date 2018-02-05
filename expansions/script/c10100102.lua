--Abscheuliche Kreatur 777
function c10100102.initial_effect(c)
	c:EnableUnsummonable()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--reducedm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100102,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetCondition(c10100102.rdcon)
	e2:SetOperation(c10100102.rdop)
	c:RegisterEffect(e2)
end
function c10100102.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c10100102.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev*2)
end