local m=110600006
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--Destroy 1 card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	-- Ritual summ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.spcost)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not(re:GetHandler():IsType(TYPE_PENDULUM) and not re:GetHandler():IsSetCard(0x303))
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_PENDULUM) and not re:GetHandler():IsSetCard(0x303)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.cfilter(c)
	return c:IsSetCard(0x303) 
end
function cm.desfilter(c)
	return cm.cfilter(c) and c:IsDestructable()
end
function cm.desfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and e:GetHandler():IsDestructable()	end
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	return Duel.Destroy(g,REASON_COST)==2
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter2,tp,0,LOCATION_ONFIELD,1,nil)end
	Duel.SelectTarget(tp,cm.desfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Destroy(tc,REASON_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,nil)
	and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.shufllefill,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,cm.shufllefill,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function cm.spfilter(c,tp,e)
	return c:IsCanBeSpecialSummoned(e,1,tp,false,false,POS_FACEUP_DEFENSE,1-tp) 
end
function cm.shufllefill(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(1-tp)
		local ntc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp,e)
		if #ntc>0 then
			Duel.SpecialSummon(ntc,1,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end