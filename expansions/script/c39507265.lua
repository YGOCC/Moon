--Synthblade - Valor
function c39507265.initial_effect(c)
    aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,39507261))
    --equip effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(300)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetValue(300)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_LEVEL)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e5:SetValue(c39507265.valcon)
    e5:SetCountLimit(1)
    c:RegisterEffect(e5)
    --special summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(39507265,1))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCost(c39507265.spcost)
    e6:SetCondition(c39507265.spcon)
    e6:SetTarget(c39507265.sptg)
    e6:SetOperation(c39507265.spop)
    c:RegisterEffect(e6)
    --to hand
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e7:SetDescription(aux.Stringid(39507265,2))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_GRAVE)
    e7:SetTarget(c39507265.tdtg)
    e7:SetOperation(c39507265.tdop)
    c:RegisterEffect(e7)
end
function c39507265.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
function c39507265.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetPreviousLocation()==LOCATION_SZONE and not c:IsReason(REASON_LOST_TARGET)
end
function c39507265.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function c39507265.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsPlayerCanSpecialSummonMonster(tp,39507265,0xf6e,0x11,1000,0,2,RACE_ROCK,ATTRIBUTE_EARTH) end
    e:SetLabel(0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c39507265.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,39507265,0xf6e,0x11,1000,0,2,RACE_ROCK,ATTRIBUTE_EARTH) then
        c:AddMonsterAttribute(TYPE_NORMAL)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        c:AddMonsterAttributeComplete()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_ATTACK)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e3,true)
        Duel.SpecialSummonComplete()
    end
end
function c39507265.thfilter(c)
    return c:IsCode(39507261) and c:IsAbleToHand()
end
function c39507265.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c39507265.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c39507265.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c39507265.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end