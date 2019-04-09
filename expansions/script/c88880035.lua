--CREATION Summon Adversery
function c88880035.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--(1) Once per turn, during the main phase, if you control a "CREATION" monster: you can target 1 monster in your deck; Special Summon that monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c88880035.condition)
	e1:SetTarget(c88880035.target)
	e1:SetOperation(c88880035.operation)
	c:RegisterEffect(e1)
	--(2) Each time a "CREATION" monster is special summoned, except by this cards effect: Draw 1 card. This effect of "CREATION Summon Adversery" can only be used once a turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,88880035)
	e2:SetTarget(c88880035.drawtg)
	e2:SetOperation(c88880035.drawop)
	c:RegisterEffect(e2)
end
--(1) Once per turn, during the main phase, if you control a "CREATION" monster: you can target 1 monster in your deck; Special Summon that monster.
function c88880035.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x889)
end
function c88880035.condition(e)
	return Duel.IsExistingMatchingCard(c88880035.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c88880035.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x889)
end
function c88880035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and c88880035.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88880035.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88880035.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88880035.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(2) Each time a "CREATION" monster is special summoned, except by this cards effect: Draw 1 card. This effect of "CREATION Summon Adversery" can only be used once a turn.
function c88880035.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88880035.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x889)
end
function c88880035.drawop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c88880035.ctfilter,1,nil) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end