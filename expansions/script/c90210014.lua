function c90210014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90210014+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c90210014.cost)
	--e1:SetTarget(c900000014.target)
	e1:SetOperation(c90210014.activate)
	c:RegisterEffect(e1)
	--Graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,90210014+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c90210014.grcost)
	e2:SetTarget(c90210014.grtarget)
	e2:SetOperation(c90210014.groperation)
	c:RegisterEffect(e2)
end
function c90210014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
end
function c90210014.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c90210014.filter2(c)
	return c:IsSetCard(0x12D) and c:IsType(TYPE_MONSTER)
end
function c90210014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210014.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c90210014.filter2,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c90210014.grcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90210014.grfilter(c,e,tp)
	return c:IsSetCard(0x12C) and c:GetCode()~=90210021 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90210014.grtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90210014.grfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c90210014.groperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90210014.grfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
