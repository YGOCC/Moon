--Steelus Acceleratem Ultima
function c192051216.initial_effect(c)
	c:EnableReviveLimit()
	--1 Dragon Tuner + 1+ Dragon non-Tuner monsters
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	--When this card is Synchro Summoned using only "Steelus" monsters as its Synchro Materials: You can return 1 card on the field to its owner's hand for each "Steelus" monster with a different name used as Synchro Material. You can only use this effect of "Steelus Acceleratem Ultima" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,192051216)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCondition(c192051216.tgcon)
	e1:SetTarget(c192051216.tgtg)
	e1:SetOperation(c192051216.tgop)
	c:RegisterEffect(e1)
end
function c192051216.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c192051216.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=e:GetHandler():GetMaterial()
		if mg==nil then return end
		local ct=mg:GetCount()
		if ct~=mg:FilterCount(Card.IsSetCard,nil,0x617) then return end
		return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
end
function c192051216.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetMaterial():GetCount()
	if Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
