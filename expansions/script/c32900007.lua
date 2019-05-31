--Guidance of the Fae
function c32900007.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunFun(c,32900001,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),2,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c32900007.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c32900007.sprcon)
    e2:SetOperation(c32900007.sprop)
    c:RegisterEffect(e2)
    --fusion limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --activate limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,1)
    e4:SetValue(c32900007.aclimit)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,1)
    e5:SetTarget(c32900007.sumlimit)
    c:RegisterEffect(e5)
    --destroy replace
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTarget(c32900007.desreptg)
    e6:SetOperation(c32900007.desrepop)
    c:RegisterEffect(e6)
end
function c32900007.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c32900007.sprfilter1(c)
    return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function c32900007.sprfilter2(c,tp,sc)
    return c:IsFaceup() and c:IsRace(RACE_FAIRY)
        and not c:IsCode(32900007) and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c32900007.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c32900007.sprfilter1,tp,LOCATION_HAND,0,2,nil)
        and Duel.IsExistingMatchingCard(c32900007.sprfilter2,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c32900007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c32900007.sprfilter1,tp,LOCATION_HAND,0,2,2,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c32900007.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
    g1:Merge(g2)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c32900007.aclimit(e,re,tp)
    return re:GetActivateLocation()==LOCATION_GRAVE
end
function c32900007.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_GRAVE)
end
function c32900007.desrepfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c32900007.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
        and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c32900007.desrepfilter),tp,LOCATION_REMOVED,0,1,nil) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function c32900007.desrepop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32900007.desrepfilter),tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)
end