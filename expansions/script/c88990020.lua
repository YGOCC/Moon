--Mecha Blade Technoshield

function c88990020.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
    e1:SetCost(c88990020.cost)
    e1:SetTarget(c88990020.target)
    e1:SetOperation(c88990020.activate)
    c:RegisterEffect(e1)
end
function c88990020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
    local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,nil,tp,1,REASON_COST)
    sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990020.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER)
end

function c88990020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c88990020.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c88990020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c88990020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c88990020.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if Duel.IsPlayerCanDraw(tp,1)
            and Duel.SelectYesNo(tp,aux.Stringid(63166095,0)) then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end
