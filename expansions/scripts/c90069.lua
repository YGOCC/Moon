--"Supercomputer"
local m=90069
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c90069.activate)
    c:RegisterEffect(e1)
    --"Special Summon"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90069,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1,90069)
    e2:SetTarget(c90069.sptg)
    e2:SetOperation(c90069.spop)
    c:RegisterEffect(e2)
    --"indestructable"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c90069.indtarget)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --"Destroy"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90069,2))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCountLimit(1)
    e4:SetTarget(c90069.target)
    e4:SetOperation(c90069.operation)
    c:RegisterEffect(e4)
    --"Draw"
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_BATTLE_DESTROYED)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetTarget(c90069.drtg)
    e5:SetOperation(c90069.drop)
    c:RegisterEffect(e5)
end
function c90069.thfilter(c)
    return c:IsCode(90700) and c:IsAbleToHand()
end
function c90069.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c90069.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(90069,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c90069.spfilter(c,e,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90069.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c90069.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90069.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c90069.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c90069.indtarget(e,c)
    return c:IsType(TYPE_NORMAL) and c:IsSetCard(0x1aa)
end
function c90069.filter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAttackAbove(2000) and c:GetSummonPlayer()==tp and not c:IsDisabled()
end
function c90069.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return eg:IsExists(c90069.filter,1,nil,1-tp) end
    Duel.SetTargetCard(eg)
    local g=eg:Filter(c90069.filter,nil,1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c90069.filter2(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAttackAbove(2000)
        and c:GetSummonPlayer()==tp and c:IsRelateToEffect(e)
end
function c90069.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c90069.filter2,nil,e,1-tp)
    local tc=g:GetFirst()
    if not tc then return end
    if g:GetCount()>1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        tc=g:Select(tp,1,1,nil):GetFirst()
    end
    if not tc:IsDisabled() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        Duel.AdjustInstantly()
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c90069.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90069.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end