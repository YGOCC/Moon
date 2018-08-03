--Tera Star the Game Master
function c12000230.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,12000230)
	e1:SetCondition(c12000230.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000230,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12001230)
	e2:SetCondition(c12000230.drcon1)
	e2:SetTarget(c12000230.drtg)
	e2:SetOperation(c12000230.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(c12000230.drcon2)
	c:RegisterEffect(e3)
end
function c12000230.cfilter(c)
	return not (c:IsSetCard(0x856) and c:IsLevelBelow(4))
end
function c12000230.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c12000230.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12000230.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x856)
		and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000230.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x856)
		and re:GetHandler():IsType(TYPE_LINK) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000230.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12000230.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
