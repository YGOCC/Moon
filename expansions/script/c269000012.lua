--Number C88 
function c269000012.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c269000012.splimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6165656,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCost(c269000012.cost)
	e3:SetTarget(c269000012.target)
	e3:SetOperation(c269000012.operation)
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c269000012.wincon)
	e4:SetOperation(c269000012.winop)
	c:RegisterEffect(e4)
end
c269000012.xyz_number=88
--target check is in RUM magic cards
function c269000012.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL)
end
function c269000012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c269000012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c269000012.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c269000012.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayCount()==0
end
function c269000012.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x18
	if Duel.GetLP(1-tp)<=2000 then
		Duel.Win(tp,WIN_REASON_DISASTER_LEO)
	else
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
end
