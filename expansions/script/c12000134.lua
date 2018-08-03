--Teutonic Order - Reinfortification
function c12000134.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Negate Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12000134.negcon)
	e2:SetOperation(c12000134.negop)
	c:RegisterEffect(e2)
	--Double Snare
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(12000134)
	c:RegisterEffect(e3)
	--Shuffle Back and Draw
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(12000134,0))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1,12000134)
    e4:SetCost(c12000134.drcost)
    e4:SetTarget(c12000134.drtg)
    e4:SetOperation(c12000134.drop)
    c:RegisterEffect(e4)
	end
--Negate Effect
function c12000134.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup() and c:IsSetCard(0x857)
end
function c12000134.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12000134.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) 
end
function c12000134.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
--Shuffle Back and Draw
function c12000134.tdfilter(c)
     return c:IsSetCard(0x857) and (c:IsAbleToDeck() or c:IsAbleToExtra())
end
function c12000134.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c12000134.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c12000134.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
    e:SetLabel(Duel.SendtoDeck(g,nil,2,REASON_EFFECT))
end
function c12000134.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c12000134.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
