--Abyssal Fireshard
local m=888801
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(cm.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(cm.damcon)
    e3:SetOperation(cm.damop)
    c:RegisterEffect(e3)
end
function cm.filter(c)
    return c:IsCode(88810101) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler() 
    local rc=re:GetHandler() 
    if c:GetFlagEffect(m)==0 and rc:IsSetCard(0xffc) 
        then c:RegisterFlagEffect(m,RESET_EVENT+RESET_CHAIN,0,1) 
    end 
end

function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetFlagEffect(m)~=0
end

function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    local totalatk=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,nil,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local a1=tc:GetAttack()
        local ATK=Effect.CreateEffect(e:GetHandler())
        ATK:SetType(EFFECT_TYPE_SINGLE)
        ATK:SetCode(EFFECT_UPDATE_ATTACK)
        ATK:SetValue(-100)
        ATK:SetReset(RESET_EVENT+RESETS_STANDARD) 
        tc:RegisterEffect(ATK)
        local a2=tc:GetAttack()
            if a1>a2 then
            totalatk=totalatk+a1-a2
            end
        tc=g:GetNext()
    end
    if totalatk>0 then
        local lp=math.floor(totalatk/2)
        Duel.Damage(1-tp,lp,REASON_ADJUST)
    end
end