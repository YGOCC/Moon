--Overlay-Mage Adept Healer
function c249000336.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43385557,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000336.reccon)
	e1:SetTarget(c249000336.rectg)
	e1:SetOperation(c249000336.recop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c249000336.destg)
	e2:SetValue(c249000336.value)
	e2:SetOperation(c249000336.desop)
	c:RegisterEffect(e2)
end
function c249000336.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c249000336.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsSetCard(0x1B3))
end
function c249000336.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c249000336.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*600)
end
function c249000336.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c249000336.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*400,REASON_EFFECT)
end

function c249000336.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsSetCard(0x1B3) or c:IsType(TYPE_XYZ))
		and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c249000336.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and eg:IsExists(c249000336.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(38981606,0)) then
		return true
	else return false end
end
function c249000336.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsSetCard(0x1B3) or c:IsType(TYPE_XYZ))
		and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c249000336.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
