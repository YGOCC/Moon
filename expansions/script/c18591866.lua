--Ninja Ghost
function c18591866.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,4),1)
    --token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18591866,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdocon)
	e1:SetTarget(c18591866.tktg)
	e1:SetOperation(c18591866.tkop)
	c:RegisterEffect(e1)
end
function c18591866.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18591867,0,0x2b,1500,1000,4,RACE_WARRIOR,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c18591866.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,18591867,0,0x2b,1500,1000,4,RACE_WARRIOR,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,18591867)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
