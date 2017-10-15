--32083016
function c32083016.initial_effect(c)
--fusion material
c:EnableReviveLimit()
aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x7D53),5,true)
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(EVENT_SPSUMMON_SUCCESS)
e1:SetCondition(c32083016.condition)
e1:SetOperation(c32083016.tgop)
c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32083016,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c32083016.bcondition)
	e2:SetTarget(c32083016.btarget)
	e2:SetOperation(c32083016.boperation)
	c:RegisterEffect(e2)
end
function c32083016.filter(c)
return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsSetCard(0x7D53)
end
function c32083016.condition(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c32083016.tgop(e,tp,eg,ep,ev,re,r,rp)
local sg=Duel.GetMatchingGroup(c32083016.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil)
Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c32083016.bfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7D53)
end
function c32083016.bcondition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c32083016.bfilter,1,nil)
end
function c32083016.btarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,nil,LOCATION_DECK)
end
function c32083016.boperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end