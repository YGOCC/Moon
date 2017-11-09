--Bushido God Ogre
function c1020054.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4B0),1,1,aux.NonTunerEx(Card.IsRace,RACE_BEASTWARRIOR),1,99)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020054.unval)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.synlimit)
	c:RegisterEffect(e2)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c1020054.aclimit)
	e4:SetCondition(c1020054.actcon)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16366810,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c1020054.damcon)
	e5:SetTarget(c1020054.damtg)
	e5:SetOperation(c1020054.damop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	if not c1020054.global_check then
		c1020054.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c1020054.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
	end
end
function c1020054.unval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():GetFlagEffect(1020054)>0
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020054.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(1020054,RESET_EVENT+RESETS_STANDARD,0,0)
		tc=eg:GetNext()
	end
end
function c1020054.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function c1020054.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c1020054.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) and Duel.GetLP(1-tp)>Duel.GetLP(tp)
end
function c1020054.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,atk)
end
function c1020054.damop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetTextAttack()
	if atk>0 then
		Duel.Damage(1-tp,atk,REASON_EFFECT,true)
		Duel.Damage(tp,atk,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
