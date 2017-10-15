
-- Modular Accel
function c444419.initial_effect(c)
    --Trap activate in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetTarget(c444419.etarget)
	e1:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e1)
	-- search
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(444419,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetCondition(c444419.drcon)
	e2:SetTarget(c444419.drtg)
	e2:SetOperation(c444419.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end
function c444419.etarget(e,c)
	return c:IsSetCard(4444)
end
function c444419.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)  and c:GetPreviousControler()==tp and c:IsSetCard(4444)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444419.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c444419.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and rp~=tp 
end
function c444419.filter(c)
	return c:IsSetCard(4444) and c:IsAbleToHand()
end
function c444419.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c444419.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444419.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c444419.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local tc=g:GetFirst()
	local c=e:GetHandler()
    local code=tc:GetOriginalCodeRule()
    local cid=0
    if Duel.GetTurnPlayer()==tp then    
        cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
    else        
        cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    end
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(444419,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_ONFIELD)
    if Duel.GetTurnPlayer()==tp then
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
    else
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    end
    e2:SetLabel(cid)
    e2:SetOperation(c444419.rstop)
    c:RegisterEffect(e2)
end
function c444419.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end