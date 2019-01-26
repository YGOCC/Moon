--Lv1 Monster
local ref=_G['c'..28915110]
local id=28915110
function ref.initial_effect(c)
	--Corona Card
	aux.EnableCoronaNeo(c,1,1,ref.matfilter,ref.matfilter2)
	--Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
end
function ref.matfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function ref.matfilter(c)
	return c:IsRace(RACE_PLANT)
end

--Summon
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,c,TYPE_CORONA)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,c,TYPE_CORONA)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
