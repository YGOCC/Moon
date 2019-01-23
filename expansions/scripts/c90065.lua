--"Hacker - Magic Hands, The Gamer"
local m=90065
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --"Special Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90065,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c90065.spcon)
    e1:SetTarget(c90065.sptg)
    e1:SetOperation(c90065.spop)
    c:RegisterEffect(e1)
    --"Damage"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90065,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c90065.damcon)
    e2:SetTarget(c90065.damtg)
    e2:SetOperation(c90065.damop)
    c:RegisterEffect(e2)
    --"Draw"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90065,2))
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,90065)
    e3:SetTarget(c90065.target)
    e3:SetOperation(c90065.operation)
    c:RegisterEffect(e3)
end
function c90065.cfilter(c,tp)
    return bit.band(c:GetPreviousTypeOnField(),TYPE_NORMAL)~=0 and c:IsSetCard(0x1aa) and c:GetPreviousControler()==tp
end
function c90065.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90065.cfilter,1,nil,tp)
end
function c90065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c90065.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
        c:CompleteProcedure()
    end
end
function c90065.damcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c90065.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c90065.damop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    Duel.Damage(p,ct*200,REASON_EFFECT)
end
function c90065.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90065.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)~=0 then
        local tc=Duel.GetOperatedGroup():GetFirst()
        Duel.ConfirmCards(1-tp,tc)
        Duel.BreakEffect()
        if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1aa) then
            if tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
                and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
                and Duel.SelectYesNo(tp,aux.Stringid(90065,0)) then
                Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
            end
        else
            Duel.SendtoGrave(tc,REASON_EFFECT)
        end
        Duel.ShuffleHand(tp)
    end
end