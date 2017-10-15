--Mysterious Tornado Dragon
function c5331123.initial_effect(c)
  --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c5331123.matfilter1),aux.FilterBoolFunction(c5331123.matfilter2),true)
end
function c5331123.matfilter1(c)
    return c:IsSetCard(0xCF6) and c:IsRace(RACE_DRAGON)
end
function c5331123.matfilter2(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
end
