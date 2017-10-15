-- Modular Armament Type D 
function c444402.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444402,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c444402.condition)
	e1:SetTarget(c444402.target)
	e1:SetOperation(c444402.operation)
	c:RegisterEffect(e1)
	-- DEF UP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetCondition(c444402.passivescondition)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(c444402.tg1)
	e2:SetValue(200)
	c:RegisterEffect(e2)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444402.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
function c444402.passivescondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  not eqc 
end
-- copy functions: target
function c444402.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c444402.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c444402.copyfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c444402.copyfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444402.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(4444)
end
-- copy functions: operation
function c444402.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
        local code=tc:GetOriginalCodeRule()
        local cid=0
        if not tc:IsType(TYPE_TRAPMONSTER) then
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(444402,1))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCountLimit(1)
        e2:SetRange(LOCATION_ONFIELD)
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        e2:SetLabel(cid)
        e2:SetOperation(c444402.rstop)
        c:RegisterEffect(e2)
    end
end
-- copy functions: reset
function c444402.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
    c:ResetEffect(cid,RESET_CARD)
end
-- DEF UP Filter
function c444402.tg1(e,c)
	return c:IsSetCard(4444)and c:IsLocation(LOCATION_MZONE)
end
