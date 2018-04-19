--Deepwood Mirror
local voc=c1906
function c1906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(voc.activate)
	c:RegisterEffect(e1)
	--Special Summon Monster
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1906+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(voc.target)
	e2:SetOperation(voc.operation)
	c:RegisterEffect(e2)
end

function voc.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5AA) and c:IsAbleToHand()
end
function voc.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(voc.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1906,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function voc.filterf(c)
	return c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function voc.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(voc.filterf,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,voc.filterf,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then end
	local tc=g:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:GetOriginalLevel()>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,2955,0,0x4011,tc:GetBaseAttack(),tc:GetBaseDefense(),
			tc:GetLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()) end
	tc:CreateEffectRelation(e)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function voc.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,2955,0,0x4011,tc:GetBaseAttack(),tc:GetBaseDefense(),
			tc:GetLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()) then return end
	tc:RegisterFlagEffect(2955,RESET_EVENT+0x17a0000,0,0)
	local token=Duel.CreateToken(tp,2955)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetBaseAttack())
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetBaseDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(RACE_PLANT)
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_EARTH)
	token:RegisterEffect(e5)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	--cannot tribute
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(voc.recon)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e6,true)
	Duel.SpecialSummonComplete()
end
function voc.recon(e,c)
	return not c:IsSetCard(0x5AA)
end