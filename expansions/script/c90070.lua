--"Cracking Board Circuit"
local m=90070
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Cracking Counter"
    c:EnableCounterPermit(0x1dc)
    --"Only One"
    c:SetUniqueOnField(1,0,90070)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Place 1 Cracking Counter"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90070,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetOperation(c90070.counter)
    c:RegisterEffect(e1)
    --"Destroy Release"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTarget(c90070.desreptg)
    e2:SetOperation(c90070.desrepop)
    c:RegisterEffect(e2)
    --"Cannot Be Destroyed"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetTargetRange(0,1)
    e3:SetValue(c90070.aclimit)
    c:RegisterEffect(e3)
    --"Handes"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90070,1))
    e4:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c90070.econ)
    e4:SetCondition(c90070.odcon)
    e4:SetCost(c90070.odcost)
    e4:SetTarget(c90070.odtarget)
    e4:SetOperation(c90070.odoperation)
    c:RegisterEffect(e4)
    --"Both Player Trade 1 Card"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(90070,2))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c90070.econ)
    e5:SetCost(c90070.ecost)
    e5:SetTarget(c90070.etarget)
    e5:SetOperation(c90070.eoperation)
    c:RegisterEffect(e5)
    --"Copy Trap"
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(90070,3))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(c90070.ctcondition)
    e6:SetTarget(c90070.cttarget)
    e6:SetOperation(c90070.ctoperation)
    c:RegisterEffect(e6)
    --"To Grave"
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(90070,4))
    e7:SetCategory(CATEGORY_DECKDES)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    e7:SetRange(LOCATION_GRAVE)
    e7:SetCountLimit(1)
    e7:SetCondition(c90070.gcondition)
    e7:SetTarget(c90070.gtarget)
    e7:SetOperation(c90070.goperation)
    c:RegisterEffect(e7)
end
function c90070.cfilter(c)
    return c:IsPreviousLocation(LOCATION_HAND)
end
function c90070.counter(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(c90070.cfilter,nil)
    if ct>0 then
        e:GetHandler():AddCounter(0x1dc,ct,true)
    end
end
function c90070.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
        and e:GetHandler():GetCounter(0x1dc)>0 end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c90070.desrepop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveCounter(ep,0x1dc,1,REASON_EFFECT)
end
function c90070.aclimit(e,re,tp)
    return re:GetHandler():IsCode(90069)
end
function c90070.odcon(e)
    return ep~=tp and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=1
end
function c90070.odcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1dc,2,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1dc,2,REASON_COST)
end
function c90070.odtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c90070.odoperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(1-tp,1)
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        local tc=sg:GetFirst()
        if tc:IsType(TYPE_MONSTER) then
            Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
        end
    end
end
function c90070.econ(e)
    return Duel.IsEnvironment(90069)
end
function c90070.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1dc,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1dc,3,REASON_COST)
end
function c90070.etarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
        and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c90070.eoperation(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g1:GetCount()==0 or g2:GetCount()==0 then return end
    Duel.ConfirmCards(tp,g2)
    Duel.ConfirmCards(1-tp,g1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local ag1=g2:Select(tp,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
    local ag2=g1:Select(1-tp,1,1,nil)
    Duel.SendtoHand(ag1,tp,REASON_EFFECT)
    Duel.SendtoHand(ag2,1-tp,REASON_EFFECT)
end
function c90070.ctcondition(e)
    return e:GetHandler():GetCounter(0x1dc)>=2
end
function c90070.ctfilter(c)
    return c:GetType()==0x4 and c:CheckActivateEffect(false,true,false)~=nil
end
function c90070.cttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        local te=e:GetLabelObject()
        local tg=te:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,1,true)
    end
    if chk==0 then return Duel.IsExistingTarget(c90070.ctfilter,tp,0,LOCATION_GRAVE,1,nil) end
    e:SetProperty(EFFECT_FLAG_CARD_TARGET)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90070,3))
    local g=Duel.SelectTarget(tp,c90070.ctfilter,tp,0,LOCATION_GRAVE,1,1,nil)
    if not g then return false end
    local te,eg,ep,ev,re,r,rp=g:GetFirst():CheckActivateEffect(false,true,true)
    e:SetLabelObject(te)
    Duel.ClearTargetCard()
    local tg=te:GetTarget()
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c90070.ctoperation(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if not te then return end
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c90070.gfilter0(c)
    return (c:IsType(TYPE_LINK) and c:GetSummonPlayer()~=tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c90070.gfilter1(c)
    return (c:IsFacedown() or c:IsType(TYPE_MONSTER)) and c:IsAbleToGrave()
end
function c90070.gcondition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90070.gfilter0,1,nil,tp)
end
function c90070.gtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
    if chk==0 then return g:FilterCount(c90070.gfilter1,nil)>=1 end
end
function c90070.goperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)
    if g:GetCount()<1 then return end
    local rg=g:RandomSelect(tp,1)
    Duel.SendtoGrave(rg,REASON_EFFECT)
end