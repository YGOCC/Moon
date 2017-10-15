-- Modular Quad Core
function c444422.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c444422.ffilter),2,true)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444422,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c444422.condition)
	e1:SetTarget(c444422.target)
	e1:SetOperation(c444422.operation)
	c:RegisterEffect(e1)
    --atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(444422,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c444422.condition)
	e2:SetOperation(c444422.daop)
	c:RegisterEffect(e2)
end
function c444422.ffilter(c)
	return  c:IsFusionSetCard(4444) and c:GetSummonLocation()==LOCATION_EXTRA
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444422.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
-- copy functions: target
function c444422.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c444422.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c444422.copyfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c444422.copyfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())	
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444422.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(4444)
end
-- copy functions: operation
function c444422.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
        local code=tc:GetOriginalCodeRule()
        local cid=0
        if not tc:IsType(TYPE_TRAPMONSTER) then
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)-- RESET_EVENT+0x007e0000+
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(444422,1))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCountLimit(1)
        e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)-- 
        e2:SetLabel(cid)
        e2:SetOperation(c444422.rstop)
        c:RegisterEffect(e2)
    end
end
-- copy functions: reset
function c444422.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
    c:ResetEffect(cid,RESET_CARD)
end

function c444422.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
	local e2=e1:Clone()
	    e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	    e2:SetValue(c:GetDefense()*2)
	    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(c444422.damval)
		e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444422.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 and rc==e:GetHandler() then
		return dam/2
	else return dam end
end
