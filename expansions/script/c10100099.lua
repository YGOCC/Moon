--Abscheuliche Kreatur 444
function c10100099.initial_effect(c)
	c:EnableUnsummonable()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c10100099.actarget)
	e4:SetCost(c10100099.costchk)
	e4:SetOperation(c10100099.costop)
	c:RegisterEffect(e4)
end
function c10100099.actarget(e,te,tp)
	return te:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and not te:GetHandler():IsSetCard(0x328) 
end
function c10100099.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,250)
end
function c10100099.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10100099)
	Duel.PayLPCost(tp,250)
end
