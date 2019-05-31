--Destruction of the Fae
function c32900013.initial_effect(c)
   --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCost(c32900013.cost)
    e1:SetTarget(c32900013.target)
    e1:SetOperation(c32900013.activate)
    c:RegisterEffect(e1)
    --chainlim
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(aux.bfgcost)
    e2:SetOperation(c32900013.op)
    c:RegisterEffect(e2)
end
c32900013.check=false
function c32900013.cfilter(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c32900013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    c32900013.check=true
    if chk==0 then return Duel.IsExistingMatchingCard(c32900013.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c32900013.cfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabel(g:GetCount())
end
function c32900013.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if not c32900013.check then return false end
        c32900013.check=false
        return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
    end
    c32900013.check=false
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c32900013.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabel(),aux.ExceptThisCard(e))
    if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_REMOVED,0,nil,32900001)>=3 then
            Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
        else
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
function c32900013.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetOperation(c32900013.actop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c32900013.actop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x13b) and ep==tp then
        Duel.SetChainLimit(c32900013.chainlm)
    end
end
function c32900013.chainlm(e,rp,tp)
    return tp==rp
end