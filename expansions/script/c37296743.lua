--Vampire Graveyard
function c37296743.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(37296743,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCondition(c37296743.spcon)
    e2:SetTarget(c37296743.sptg)
    e2:SetOperation(c37296743.spop)
    c:RegisterEffect(e2)
end
function c37296743.spfilter(c)
    return c:IsPreviousLocation(0x7) and c:IsRace(RACE_ZOMBIE)
end
function c37296743.spcon(e,tp,eg,ep,ev,re,r,rp)
    if eg:IsExists(c37296743.filter,1,nil) then
        e:SetLabel(1)
        return true
    elseif eg:IsExists(c37296743.spfilter,1,nil) then
        return true
    else return false
    end
end
function c37296743.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c37296743.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,37296744,0,0x8e,1000,1000,2,RACE_ZOMBIE,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,37296744)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        if e:GetLabel()==1 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_SET_ATTACK)
            e1:SetValue(1800)
            e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,37296743))
            e1:SetReset(RESET_EVENT+0x1ff0000)
            token:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_SET_DEFENSE)
            c:RegisterEffect(e2)
        end
    end
end
function c37296743.filter(c)
    if not c:IsPreviousLocation(0x7) or not c:IsSetCard(0x8e) then return end
    return c:IsRace(RACE_ZOMBIE)
end