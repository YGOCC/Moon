--"Hacker - V-TRIX, The Cheater"
local m=90064
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --"Special Summon Condition"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(0)
    c:RegisterEffect(e1)
    --"Special Summon"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c90064.spcon)
    e2:SetOperation(c90064.spop)
    c:RegisterEffect(e2)
    --"Life Points Up"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90064,0))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c90064.operation)
    c:RegisterEffect(e3)    
    --"ATK UP"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90064,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DAMAGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetCondition(c90064.atkcon)
    e4:SetOperation(c90064.atkop)
    c:RegisterEffect(e4)
    --"Deck Destroy"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(90064,2))
    e5:SetCategory(CATEGORY_DECKDES)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetTarget(c90064.htarget)
    e5:SetOperation(c90064.hoperation)
    c:RegisterEffect(e5)
end
function c90064.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1aa) and c:IsAbleToGraveAsCost()
end
function c90064.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c90064.spfilter,c:GetControler(),LOCATION_HAND,0,3,c)
end
function c90064.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c90064.spfilter,tp,LOCATION_HAND,0,3,3,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function c90064.filter1(c,tp)
    return c:GetOwner()==1-tp
end
function c90064.operation(e,tp,eg,ep,ev,re,r,rp)
    local d1=eg:FilterCount(c90064.filter1,nil,tp)*200
    Duel.Recover(tp,d1,REASON_EFFECT,true)
    Duel.RDComplete()
end
function c90064.atkcon(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp and bit.band(r,REASON_BATTLE)==0
end
function c90064.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ev)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c90064.htarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,5)
end
function c90064.hoperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end