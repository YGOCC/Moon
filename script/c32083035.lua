--D.D. Eternal End Dragon
function c32083035.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c32083035.tfilter,aux.NonTuner(Card.IsSetCard,0x7D53),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTarget(c32083035.rmtg)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c32083035.descon1)
	e2:SetTarget(c32083035.destg)
	e2:SetOperation(c32083035.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c32083035.descon2)
	e3:SetTarget(c32083035.destg)
	e3:SetOperation(c32083035.desop)
	c:RegisterEffect(e3)
end
function c32083035.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c32083035.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32083035.tgfilter,1,nil,tp)
end
function c32083035.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c32083035.tgfilter,1,nil,tp)
end
function c32083035.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c32083035.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c32083035.tfilter(c)
	return c:IsSetCard(0x7D53)
end
function c32083035.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
