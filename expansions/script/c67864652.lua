--Mekbuster Frame LS3-I6
function c67864652.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,67864641,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,true,true)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864652,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,67864652)
	e1:SetCondition(c67864652,mvcon)
	e1:SetTarget(c67864652.mvtg)
	e1:SetOperation(c67864652.mvop)
	c:RegisterEffect(e1)
end
function c67864652.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end