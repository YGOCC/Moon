--Mecha Blade Base Defender
local m=88880212
local cm=_G["c"..m]
function cm.initial_effect(c)
--xyz summon
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetCondition(cm.damcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetValue(cm.damval)
    c:RegisterEffect(e3)
end
function cm.mfilter(c)
    return c:IsSetCard(0xffd)
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
function cm.atkval(e,c)
    return c:GetOverlayCount()*500
end
function cm.damval(e,re,val,r,rp,rc)
    local def=e:GetHandler():GetDefense()
    if val<=def then return 0 else return val end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetOverlayCount()>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
