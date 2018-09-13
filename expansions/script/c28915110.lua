--Lv1 Monster
local ref=_G['c'..28915110]
local id=28915110
function ref.initial_effect(c)
	--Corona Card
	aux.EnableCorona(c,nil,2,99,TYPE_MONSTER+TYPE_EFFECT,ref.gmatfilter)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CORONA_DRAW_COST)
	e0:SetValue(ref.coronacost)
	c:RegisterEffect(e0)
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
function ref.coronacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function ref.gmatfilter(eg)
	return Duel.CheckChainUniqueness()
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
