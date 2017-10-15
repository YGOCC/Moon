--Saber Yasmin of Gust VINE
function c160002156.initial_effect(c)
	c:EnableReviveLimit()
		--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c160002156.efilter)
	c:RegisterEffect(e1)
		--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160002156,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,160002156)
	e2:SetCondition(c160002156.drcon)
	e2:SetTarget(c160002156.drtg)
	e2:SetOperation(c160002156.drop)
	c:RegisterEffect(e2)
		--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG2_XMDETACH+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c160002156.discon)
	e3:SetCost(c160002156.discost)
	e3:SetTarget(c160002156.distg)
	e3:SetOperation(c160002156.disop)
	c:RegisterEffect(e3)
	if not c160002156.global_check then
		c160002156.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c160002156.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c160002156.evolute=true
c160002156.material1=function(mc) return mc:IsAttribute(ATTRIBUTE_WIND) and (mc:GetLevel()==2 or mc:GetRank()==2) and mc:IsFaceup() end
c160002156.material2=function(mc) return mc:IsRace(RACE_SPELLCASTER) and (mc:GetLevel()==2 or mc:GetRank()==2) and mc:IsFaceup() end
function c160002156.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c160002156.stage_o=4
c160002156.stage=c160002156.stage_o
end
function c160002156.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_TRAP)
end

function c160002156.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c160002156.discost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,4,REASON_COST)
end
function c160002156.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160002156.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c160002156.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c160002156.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c160002156.drop(e,tp,eg,ep,ev,re,r,rp)
		Duel.DiscardDeck(tp,4,REASON_EFFECT)
end

