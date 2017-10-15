--Numeral-Mage White Protector
function c249000404.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000404.spcon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5818294,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,249000404)
	e2:SetCondition(c249000404.negcon)
	e2:SetCost(c249000404.negcost)
	e2:SetTarget(c249000404.negtg)
	e2:SetOperation(c249000404.negop)
	c:RegisterEffect(e2)
end
function c249000404.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1B9) and c:GetCode()~=249000404 and c:GetCode()~=249000401
end
function c249000404.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c249000404.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c249000404.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and (c:IsSetCard(0x48) or  c:IsSetCard(0x1B9))
end
function c249000404.confilter(c)
	return c:IsSetCard(0x1B9) and not c:IsCode(249000404)
end
function c249000404.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c249000404.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c249000404.confilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c249000404.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c249000404.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c249000404.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end