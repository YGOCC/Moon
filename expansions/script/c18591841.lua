--ASSASSIN - LILLY, THE RECRUITER
function c18591841.initial_effect(c)
    --Link summon
    aux.AddLinkProcedure(c,c18591841.matfilter,2)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(7391448,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCondition(c18591841.spcon)
    e1:SetTarget(c18591841.sptg)
    e1:SetOperation(c18591841.spop)
    c:RegisterEffect(e1)
end
function c18591841.matfilter(c)
    return c:IsSetCard(0x50e)
end
function c18591841.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not c:IsRelateToBattle() or c:IsFacedown() then return false end
    return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c18591841.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetTargetCard(bc)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,LOCATION_GRAVE)
end
function c18591841.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
