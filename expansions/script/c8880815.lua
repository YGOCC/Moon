--Mechia Mechafortress
local m=8880815
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_FZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(cm.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.thcon)
    e3:SetTarget(cm.settg)
    e3:SetOperation(cm.setop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.settg)
    e4:SetOperation(cm.setop)
    c:RegisterEffect(e4)
end
function cm.tgtg(e,c)
    return c:IsSetCard(0xff8) and c~=e:GetHandler()
end
function cm.thfilter2(c,tp)
    return c:IsSetCard(0xff8) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.thfilter2,1,nil,tp)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end
function cm.setfilter(c)
    return c:IsSetCard(0xff8) and not c:IsForbidden() and c:IsType(TYPE_MONSTER)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil):GetFirst()
    if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
       local e1=Effect.CreateEffect(e:GetHandler())
       e1:SetCode(EFFECT_CHANGE_TYPE)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
       e1:SetReset(RESET_EVENT+0x1fc0000)
       e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
       tc:RegisterEffect(e1)
       tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,0,1)
    end
end