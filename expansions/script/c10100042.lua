--Stygische Unsterblichkeit
function c10100042.initial_effect(c)
    --snychrosummon  
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,50732780),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c10100042.htg)
	e1:SetOperation(c10100042.hop)
	c:RegisterEffect(e1)
  	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100042,1))
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c10100042.cost)
	e3:SetTarget(c10100042.target)
	e3:SetOperation(c10100042.operation)
	c:RegisterEffect(e3)
end
function c10100042.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10100043,0,0x4011,700,2450,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10100042.hop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10100043,0,0x4011,700,2450,6,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,10100043)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)	
		local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10100042.synlimit)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e2)
end
function c10100042.filter1(c)
	return c:IsCode(50732780) and c:IsAbleToHand()
end
function c10100042.filter2(c)
	return c:IsSetCard(0x323) and c:IsType(TYPE_MONSTER) or c:IsCode(13521194) or c:IsCode(86137485) and not c:IsCode(50732780) and c:IsAbleToRemoveAsCost()
end
function c10100042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100042.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100042.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100042.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c10100042.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100042.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
