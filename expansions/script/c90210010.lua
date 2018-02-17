function c90210010.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,90210010)
	e2:SetCondition(c90210010.spcon)
	e2:SetOperation(c90210010.spop)
	c:RegisterEffect(e2)
	--destroy trap&spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90210004,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c90210010.target)
	e3:SetOperation(c90210010.activate)
	c:RegisterEffect(e3)
	--special
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c90210010.filter(c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130) and c:IsAbleToDeckAsCost()
end
function c90210010.filtersp(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function c90210010.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90210010.filter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c90210010.filtersp,tp,0,LOCATION_MZONE,1,nil)
end
function c90210010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c90210010.filter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
end
function c90210010.tfilter(c)
	return c:IsDestructable()
end
function c90210010.cfilter(c)
	return c:IsSetCard(0x12C) and c:IsAbleToGrave() or c:IsSetCard(0x12D) and c:IsAbleToGrave()
	or c:IsSetCard(0x130) and c:IsAbleToGrave()
end
function c90210010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c90210010.tfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c90210010.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c90210010.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c90210010.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c90210010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c90210010.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end