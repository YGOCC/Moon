--雨宫文绪·夏物语
function c81011025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81011025)
	e1:SetCondition(c81011025.sprcon)
	c:RegisterEffect(e1)	
end
function c81011025.cfilter(c)
	return c:IsFacedown() or not c:IsLevel(8)
end
function c81011025.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c81011025.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
