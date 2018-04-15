--Number C300: Galaxy-Eyes Singularity Dragon
function c88880016.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),9,5)
	c:EnableReviveLimit()
	--(1) spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88880016.splimit)
	c:RegisterEffect(e1)
	--(2) Imunity to destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--(3) add spell card
	--(4) ATK increase and effect negation
	--(5) ATK gain
	
end
--(1) spsummon limit
function c88880016.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95)
end
--(3) Add Spell card
--(4) ATK Increase and negate effect activation
--(5) ATK gain
