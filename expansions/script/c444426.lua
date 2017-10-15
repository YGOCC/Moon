function c444426.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,4444),6,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)	
	e1:SetOperation(c444426.operation)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(444426,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
    e2:SetCountLimit(1)   
    e2:SetCondition(c444426.condition)
    e2:SetCost(c444426.cost)
    e2:SetOperation(c444426.deop)
    c:RegisterEffect(e2)
end

function c444426.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local eqc=c:GetEquipTarget()
    return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
function c444426.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.RaiseEvent(e:GetHandler(),444426,e,0,0,0,0)
    local c=e:GetHandler() 
    c:ResetEffect(0xff,RESET_COPY)
    local wg=c:GetOverlayGroup()
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0  then
            local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
            c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
            local e0=Effect.CreateEffect(c)
            e0:SetCode(444426)
            e0:SetLabel(code)
            e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2) 
            c:RegisterEffect(e0,true)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_ADJUST)
            e1:SetRange(LOCATION_ONFIELD)
            e1:SetLabel(cid)
            e1:SetLabelObject(e0)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetOperation(c444426.resetop)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e1,true)
        end
        wbc=wg:GetNext()
    end
end
function c444426.codefilter(c,code)
    return c:GetOriginalCode()==code and c:IsSetCard(4444)
end
function c444426.resetop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetOverlayGroup()
    if not g:IsExists(c444426.codefilter,1,nil,e:GetLabelObject():GetLabel()) or c:IsDisabled() then
        c:ResetEffect(e:GetLabel(),RESET_COPY)
        c:ResetFlagEffect(e:GetLabelObject():GetLabel())
    end
end


function c444426.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
    Duel.Hint(HINT_SELECTMSG,tp,532)
    local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,nil,tp,1,REASON_COST)
    sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end

function c444426.deop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc1=Duel.SelectMatchingCard(tp,c444426.attachfilter,tp,LOCATION_DECK, 0, 1, 1,nil):GetFirst()
    local tc2=Duel.SelectMatchingCard(tp,c444426.XYZfilter, tp, LOCATION_MZONE, 0, 1, 1,nil):GetFirst()
    Duel.Overlay(tc2,tc1)
end

function c444426.XYZfilter(c)
    return c:IsType(TYPE_XYZ)
end

function c444426.attachfilter(c)
    return c:IsSetCard(4444)
end