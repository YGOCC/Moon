--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916208]
local id=28916208
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,28916208)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,128916208)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
--Kinny was here
ref.fit_monster={28916204}
function ref.GYAble(c)
	return c:IsAbleToGrave()
end
function ref.SearchVolta(c)
	return c:IsCode(28916204) and c:IsAbleToHand()
end
function ref.RitMonster(c,e,tp)
	return c:IsSetCard(1858) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false,POS_FACEUP,tp)
end
function ref.RitMat(c)
	return (c:IsSetCard(1858) or c:IsSetCard(1859)) and c:IsAbleToGrave()
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.RitMat,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(ref.RitMonster,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.SelectMatchingCard(tp,ref.RitMat,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if Duel.Release(g0,REASON_EFFECT)~=0 then
		local g1=Duel.SelectMatchingCard(tp,ref.RitMonster,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g1,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(ref.GYAble,tp,LOCATION_ONFIELD,0,1,nil) end
	if chkc then return ref.GYAble(chkc) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) end
	local ct=1
	if (Duel.IsExistingMatchingCard(ref.SearchVolta,tp,LOCATION_DECK,0,1,nil)) then ct=2 end
	local g0 = Duel.SelectTarget(tp,ref.GYAble,tp,LOCATION_ONFIELD,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
	if g0:GetCount()==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Release(g0,REASON_EFFECT)
	if ct~=0 then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
	end
	if ct==2 then
		local g3=Duel.SelectMatchingCard(tp,ref.SearchVolta,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoHand(g3,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
		end
	end
end
