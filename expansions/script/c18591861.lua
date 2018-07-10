--Master Of Supreme Lighting
function c18591861.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,18591857,18591860,true,true)
    --attack all
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ATTACK_ALL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
end