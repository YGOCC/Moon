--Mechia Legion
local m=8880803
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    local act=Effect.CreateEffect(c)
    act:SetDescription(aux.Stringid(m,0))
    act:SetType(EFFECT_TYPE_FIELD)
    act:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    act:SetCode(EFFECT_SPSUMMON_PROC_G)
    act:SetRange(LOCATION_HAND)
    act:SetCountLimit(1,8880803)
    act:SetLabelObject(e0)
    act:SetCondition(cm.actcon)
    act:SetOperation(cm.actop)
    c:RegisterEffect(act)
    local e2=Effect.CreateEffect(c)  
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,8882803)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.op)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetRange(LOCATION_ONFIELD)
    e1:SetCountLimit(1,8881803)
    e1:SetTarget(cm.target2)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)    
end
function cm.actcon(c,e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp,c)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE,0)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    local kp=Effect.CreateEffect(c)
    kp:SetType(EFFECT_TYPE_SINGLE)
    kp:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    kp:SetCode(EFFECT_REMAIN_FIELD)
    kp:SetReset(RESET_EVENT+0x1fc0000)
    c:RegisterEffect(kp)
    local te=c:GetActivateEffect()
    Duel.RaiseEvent(c,EVENT_CUSTOM+m,te,0,tp,tp,0)
    Duel.Hint(HINT_CARD,0,m)
    if not Duel.IsCanAddCounter(tp,0x1555,2,c) then return end
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,tp,0)
end

function cm.cfilter(c)
    return c:IsSetCard(0xff8) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable()
        and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.setfilter(c)
    return c:IsSetCard(0xff8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local v=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g1=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc1=g1:GetFirst()
    if g1:GetCount()>0 then
        Duel.SSet(tp,tc1)
        Duel.ConfirmCards(1-tp,g1)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
            e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc1:RegisterEffect(e1)
    end
end

function cm.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
 local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end