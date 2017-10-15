--Lovely Paintress Goghi
function c160002321.initial_effect(c)
	c:EnableReviveLimit()
		--atk
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(160002321,1))
	e99:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e99:SetType(EFFECT_TYPE_QUICK_O)
	e99:SetCode(EVENT_FREE_CHAIN)
	e99:SetRange(LOCATION_MZONE)
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e99:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e99:SetCountLimit(1)
	e99:SetCost(c160002321.cost)
	e99:SetTarget(c160002321.target)
	e99:SetOperation(c160002321.operation)
	c:RegisterEffect(e99)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160002321,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c160002321.sscon)
	e2:SetCost(c160002321.cost2)
	e2:SetTarget(c160002321.target2)
	e2:SetOperation(c160002321.operation2)
	c:RegisterEffect(e2)
	if not c160002321.global_check then
		c160002321.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c160002321.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c160002321.evolute=true
c160002321.stage_o=5
c160002321.stage=c160002321.stage_o
c160002321.material1=function(mc) return mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsType(TYPE_NORMAL) and mc:GetLevel()==2 and mc:IsFaceup() end
c160002321.material2=function(mc) return mc:IsRace(RACE_FAIRY) and mc:IsType(TYPE_NORMAL) and mc:GetLevel()==3 and mc:IsFaceup() end
function c160002321.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)

end

function c160002321.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_NORMAL) and (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c160002321.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,2,REASON_COST) and Duel.IsExistingMatchingCard(c160002321.costfilter,tp,LOCATION_EXTRA,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160002321.costfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveCounter(tp,0x1088,2,REASON_COST)
end
function c160002321.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c160002321.filtersex(c)
	return c:IsFaceup()  and not c:IsDisabled()
end
function c160002321.sscon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()~=tp
end
function c160002321.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c160002321.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160002321.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c160002321.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c160002321.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled()  then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end

function c160002321.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c160002321.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c160002321.filtersex(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160002321.filtersex,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c160002321.filtersex,tp,0,LOCATION_ONFIELD,1,1,nil)
end


function c160002321.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end