--Mike, The Commander Of The Assassins
function c18591834.initial_effect(c)
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591834,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCondition(aux.bdocon)
    e1:SetTarget(c18591834.target)
    e1:SetOperation(c18591834.operation)
    c:RegisterEffect(e1)
end
function c18591834.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
end
function c18591834.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,18591835,0,0x50e,1600,1000,2,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
    local token=Duel.CreateToken(tp,18591835)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UNRELEASABLE_SUM)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    token:RegisterEffect(e1)
end