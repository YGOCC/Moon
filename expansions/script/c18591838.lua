--WYATT, KILLER SMOKE
function c18591838.initial_effect(c)
    --Link summon
    aux.AddLinkProcedure(c,c18591838.matfilter,2)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c18591838.atkval)
    c:RegisterEffect(e1)
end
function c18591838.matfilter(c)
    return c:IsSetCard(0x50e) and c:IsLevel(4)
end
function c18591838.atkval(e,c)
    local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
    return g:GetSum(Card.GetBaseAttack)
end
function c18591838.antg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c18591838.cfilter(c,lg)
    return c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c18591838.thcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return eg:IsExists(c18591838.cfilter,1,nil,lg)
end