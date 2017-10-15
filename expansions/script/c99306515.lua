--Mysterious Star Dragon
function c99306515.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c(99306515).matfilter,7,2)
    c:EnableReviveLimit()

c99306515.matfilter(c)
       return c:IsSetCard(0xCF6) or c:IsSetCard(0xCF7) 0r c:IsSetCard(0xCF8)
end
