--Seatector Admiral
function c83013177.initial_effect(c)
	c:EnableReviveLimit()
	--link prochedure
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),2)
	--link summon once per turn
	c:SetSPSummonOnce(SUMMON_TYPE_LINK)
	--if it link summoned
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c83013177.seqcon)
	e1:SetTarget(c83013177.seqtg)
	e1:SetOperation(c83013177.seqop)
	c:RegisterEffect(e1)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c83013177.eqcos)
	e2:SetTarget(c83013177.eqtg)
	e2:SetOperation(c83013177.eqop)
	c:RegisterEffect(e2)
end
function c83013177.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c83013177.eqfilter(c,ec)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_UNION)
		and c:CheckEquipTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function c83013177.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c83013177.eqfilter,tp,LOCATION_DECK,0,1,nil,c) end
end
function c83013177.seqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local eqg=Duel.SelectMatchingCard(tp,c83013177.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local eqc=eqg:GetFirst()
	if eqc and c:IsFaceup() and c:IsRelateToEffect(e) 
		and aux.CheckUnionEquip(eqc,c) and Duel.Equip(tp,eqc,c) then
		aux.SetUnionState(eqc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		eqc:RegisterEffect(e1)
	end
end
function c83013177.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function c83013177.eqcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83013177.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c83013177.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c83013177.eqfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c83013177.eqfilter2,tp,LOCATION_MZONE,0,1,nil,c) and c:IsSetCard(0x33f)
end
function c83013177.eqfilter2(c,ec)
	return ec:CheckEquipTarget(c)
end
function c83013177.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c83013177.eqfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c83013177.eqfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SelectTarget(tp,c83013177.eqfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function c83013177.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c83013177.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc)
		local gc=g:GetFirst()
		if gc and Duel.Equip(tp,tc,gc) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetAttack()/2)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			gc:RegisterEffect(e1)
		end
	end
end
--[[
	Seatector
	2 WATER monsters
	You can only Link summon “Seatector Admaral(s)” once per turn.
	If this card is Link Summoned: you can  equip 1 WATER Union monster from your Deck to this card.
	Once per turn: you can discard 1 WATER Monster, then target 1 “Seatector” monster in your GY: equip it to 1 of your monsters, also that  monster gain ATK equal to half equipped monsters ATK, until the end of the turn.
--]]