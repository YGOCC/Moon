--Deepwood Leafman
local voc=c1902
function c1902.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(voc.spcon)
	c:RegisterEffect(e2)
	
	--destroy monster
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(1902,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(voc.cost)
	e3:SetTarget(voc.target)
	e3:SetOperation(voc.activate)
	c:RegisterEffect(e3)
end
function voc.cfilter(c)
	return (c:IsFacedown() or not c:IsRace(RACE_PLANT)) and c:IsType(TYPE_MONSTER)
end
function voc.filtersp(c)
	return c:IsFaceup() and c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER)
end
function voc.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(voc.filtersp,c:GetControler(),0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(voc.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function voc.cfilter(c)
	return c:IsSetCard(0x5AA) and c:IsDiscardable()
end
function voc.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(voc.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,voc.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function voc.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function voc.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Destroy(g,REASON_EFFECT)
end
