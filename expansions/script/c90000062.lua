--Operation - Sabotage
function c90000062.initial_effect(c)
	--Seal Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90000062,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c90000062.condition)
	e1:SetTarget(c90000062.target)
	e1:SetOperation(c90000062.operation)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90000062,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c90000062.condition)
	e2:SetTarget(c90000062.target2)
	e2:SetOperation(c90000062.operation2)
	c:RegisterEffect(e2)
end
function c90000062.filter(c,tp)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_MONSTER)
end
function c90000062.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c90000062.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c90000062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c90000062.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c90000062.tg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c90000062.tg(e,c)
	return c:IsCode(e:GetLabel())
end
function c90000062.filter2(c)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c90000062.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000062.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c90000062.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function c90000062.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c90000062.filter2,tp,LOCATION_GRAVE,0,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct==0 then return end
	Duel.Recover(tp,ct*1000,REASON_EFFECT)
end