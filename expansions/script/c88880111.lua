--Mecha Blade Blood Queen
local m=88880111
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
--xyz summon
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.drcon1)
    e1:SetOperation(cm.damop1)
    c:RegisterEffect(e1)
    --sp_summon effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.regcon)
    e2:SetOperation(cm.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.drcon2)
    e3:SetOperation(cm.drop2)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,m)
    e4:SetCondition(cm.spcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
end
function cm.mfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.filter(c,sp)
    return c:GetSummonPlayer()==sp
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.filter,1,nil,1-tp) 
        and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.filter,1,nil,1-tp) 
        and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.cfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xffd) and not c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
    and Duel.GetFlagEffect(tp,m)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
    end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
    local n=Duel.GetFlagEffect(tp,m)
    Duel.ResetFlagEffect(tp,m)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,300,REASON_EFFECT)
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Recover(tp,300,REASON_EFFECT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
    end
end