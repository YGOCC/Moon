--"Cyberon Energy Eater"
--by "Márcio Eduine"
local m=90000
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Special Summon(Hand)"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(c90000.spcon)
    c:RegisterEffect(e0)
    --"Special Summon(GY)"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90000,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetTarget(c90000.target)
    e1:SetOperation(c90000.operation)
    c:RegisterEffect(e1)
end
function c90000.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x20aa) and c:GetCode()~=90000
end
function c90000.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c90000.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c90000.filter(c)
    return c:IsFaceup() and c:IsAttackAbove(500)
end
function c90000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c90000.filter(chkc) end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(c90000.filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90000,1))
    Duel.SelectTarget(tp,c90000.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c90000.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:GetAttack()<500 then return end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(-500)
    tc:RegisterEffect(e1)
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end