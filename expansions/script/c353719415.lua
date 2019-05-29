function c353719415.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,353719415)
	e1:SetOperation(c353719415.activate)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c353719415.condition)
	e2:SetTarget(c353719415.sptg)
	e2:SetOperation(c353719415.spop)
	e2:SetCountLimit(1,353719433)
	c:RegisterEffect(e2)
	end
function c353719415.filter(c)
	return c:IsCode(353719405) or c:IsCode(353719424) and c:IsAbleToHand()
end
function c353719415.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c353719415.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(353719415,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c353719415.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if g:GetCount()~=1 then return false end
	local c=g:GetFirst()
	return c:IsFaceup() and c:IsSetCard(0x701)
end
function c353719415.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c353719415.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,353719418,0x101b,0x4011,0,0,3,RACE_ROCK,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,353719418)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end