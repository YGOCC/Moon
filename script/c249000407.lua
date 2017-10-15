--Time the Temporal Transcender
function c249000407.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000407.spcon)
	e2:SetOperation(c249000407.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(983995,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,249000407)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c249000407.target)
	e3:SetOperation(c249000407.operation)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(652362,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,2490004071)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c249000407.target2)
	e4:SetOperation(c249000407.operation2)
	c:RegisterEffect(e4)
end
function c249000407.spfilter(c)
	return c:IsSetCard(0x1BA) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c249000407.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000407.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c249000407.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000407.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000407.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c249000407.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(4)
end
function c249000407.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000407.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c249000407.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000407.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c249000407.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local race=tc:GetRace()
	local lv=tc:GetLevel() * 2
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	local ac=Duel.AnnounceCard(tp)
	local cc=Duel.CreateToken(tp,ac)
	if ((cc:GetLevel()==lv or cc:GetLevel()==lv - 1 or cc:GetLevel()==lv + 1) and cc:IsCanBeSpecialSummoned(e,0,tp,false,false) and
	(not (cc:IsType(TYPE_RITUAL) or cc:IsType(TYPE_FUSION) or cc:IsType(TYPE_SYNCHRO) or cc:IsType(TYPE_XYZ)))) then
		Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)
	end
end