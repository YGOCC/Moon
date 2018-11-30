--"Demon Espadachim of the Divine Flames"
local m=70012
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Material"
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,70010,c70012.ffilter,1,true,true)
    --"Equip"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70012,0))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c70012.condition)
    e2:SetTarget(c70012.target)
    e2:SetOperation(c70012.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(70012,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c70012.eqtg)
    e3:SetOperation(c70012.eqop)
    c:RegisterEffect(e3)
    --"Draw"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(70012,2))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c70012.drcost)
    e4:SetTarget(c70012.drtarget)
    e4:SetOperation(c70012.droperation)
    c:RegisterEffect(e4)
    --"Race change"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(70012,3))
    e5:SetCode(EFFECT_CHANGE_RACE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c70012.atttg)
    e5:SetOperation(c70012.attop)
    c:RegisterEffect(e5)
end
c70012.material_setcode=0x509
function c70012.ffilter(c)
    return c:IsSetCard(0x509) and c:IsLevelBelow(4)
end
function c70012.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c70012.filter(c,ec)
    return c:IsCode(80000) and c:CheckEquipTarget(ec)
end
function c70012.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c70012.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c70012.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,c70012.filter,tp,LOCATION_DECK,0,1,1,nil,c)
    local tc=g:GetFirst()
    if tc then
        Duel.Equip(tp,tc,c,true)
    end
end
function c70012.eqfilter(c,tp)
    return (c:IsSetCard(0x509) and c:IsType(TYPE_MONSTER)) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c70012.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c70012.eqfilter,tp,LOCATION_HAND,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c70012.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,c70012.eqfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c70012.eqlimit)
        tc:RegisterEffect(e1)
        local atk=tc:GetTextAttack()
        if atk>0 then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_EQUIP)
            e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            e2:SetValue(atk)
            tc:RegisterEffect(e2)
        end
    end
end
function c70012.eqlimit(e,c)
    return e:GetOwner()==c
end
function c70012.drfilter(c,ec)
    return c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function c70012.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70012.drfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c70012.drfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c70012.drtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c70012.droperation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c70012.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
    local aat=Duel.AnnounceRace(tp,1,0x8-e:GetHandler():GetRace())
    e:SetLabel(aat)
end
function c70012.attop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c70012.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
    local aat=Duel.AnnounceRace(tp,1,RACE_FIEND-e:GetHandler():GetRace())
    e:SetLabel(aat)
end
function c70012.attop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
        c:RegisterEffect(e1)
    end
end