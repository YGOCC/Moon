-- Modular Dual Core
function c444421.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,4444),2,true)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444421,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c444421.condition)
	e1:SetTarget(c444421.target)
	e1:SetOperation(c444421.operation)
	c:RegisterEffect(e1)
    -- atk again
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(444421,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c444421.condition)
	e2:SetOperation(c444421.daop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(444421,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)

	e3:SetCondition(c444421.drcon)
	e3:SetTarget(c444421.drtg)
	e3:SetOperation(c444421.drop)
	c:RegisterEffect(e3)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444421.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
-- copy functions: target
function c444421.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c444421.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c444421.copyfilter,tp,LOCATION_ONFIELD+LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c444421.copyfilter,tp,LOCATION_ONFIELD+LOCATION_PZONE,0,1,1,e:GetHandler())	
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444421.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(4444)
end
-- copy functions: operation
function c444421.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
        local code=tc:GetOriginalCodeRule()
        local cid=0
        if not tc:IsType(TYPE_TRAPMONSTER) then
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)-- RESET_EVENT+0x007e0000+
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(444421,1))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCountLimit(1)
        e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)-- 
        e2:SetLabel(cid)
        e2:SetOperation(c444421.rstop)
        c:RegisterEffect(e2)
    end
end
-- copy functions: reset
function c444421.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
    c:ResetEffect(cid,RESET_CARD)
end
function c444421.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444421.drcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 -- bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and
end
function c444421.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c444421.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end

