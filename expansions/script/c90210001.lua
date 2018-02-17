function c90210001.initial_effect(c)
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
	e2:SetCountLimit(1,90210001)
	e2:SetCondition(c90210001.spcon)
	e2:SetOperation(c90210001.spop)
	c:RegisterEffect(e2)
	--summon draw cards
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c90210001.drtg)
	e3:SetOperation(c90210001.drop)
	c:RegisterEffect(e3)
	--special
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c90210001.filtersp(c)
	return c:IsFaceup() and c:IsAttackBelow(2500)
end
function c90210001.filter(c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130) and c:IsAbleToDeckAsCost()
end
function c90210001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90210001.filter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c90210001.filtersp,tp,0,LOCATION_MZONE,1,nil)
end
function c90210001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c90210001.filter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
end
function c90210001.filterd(c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D)
end
function c90210001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c90210001.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end