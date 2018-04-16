--created & coded by Lyris
--機光襲雷竜－ビッグバン
function c240100029.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c240100029.ffilter,2,true)
	c:EnableCounterPermit(0x4b)
	c:SetCounterLimit(0x4b,5)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c240100029.descon)
	e3:SetTarget(c240100029.destg)
	e3:SetOperation(c240100029.desop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADD_COUNTER+0x4b)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetCounter(0x4b)>=4 end)
	e1:SetTarget(c240100029.destg)
	e1:SetOperation(c240100029.desop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c240100029.tgcon)
	e0:SetValue(aux.imval1)
	c:RegisterEffect(e0)
	local e5=e0:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c240100029.acop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(function(e) return e:GetHandler():GetCounter(0x1b)==5 end)
	e4:SetTarget(c240100029.target)
	e4:SetOperation(c240100029.activate)
	c:RegisterEffect(e4)
end
function c240100029.ffilter(c,fc,sub,mg,sg)
	return c:IsSetCard(0x7c4) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(c240100029.fcheck,1,c,c:GetAttack()))
end
function c240100029.fcheck(c,atk)
	local dif=math.abs(c:GetAttack()-atk)
	return dif>0 and dif<=400
end
function c240100029.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100029.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c240100029.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c240100029.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c4)
end
function c240100029.tgcon(e)
	return Duel.IsExistingMatchingCard(c240100029.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c240100029.filter(c,tp)
	return (not (c:IsPreviousLocation(LOCATION_MZONE) or c:GetPreviousControler()~=tp) or c:IsPreviousPosition(POS_FACEUP)) and not c:IsPreviousLocation(LOCATION_SZONE) and c:IsSetCard(0x7c4)
end
function c240100029.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c240100029.filter,e:GetHandler(),tp)
	if ct>0 then
		e:GetHandler():AddCounter(0x4b,ct,true)
	end
end
function c240100029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c240100029.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
