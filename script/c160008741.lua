--Paintress Dragon
function c160008741.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160008741,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCost(c160008741.eqcost)
	e1:SetCondition(c160008741.descon)
	e1:SetTarget(c160008741.destg)
	e1:SetOperation(c160008741.desop)
	c:RegisterEffect(e1)
	--change type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetOperation(c160008741.regop)
	c:RegisterEffect(e3)
			--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c160008741.atkval)
	c:RegisterEffect(e4)
		if not c160008741.global_check then
		c160008741.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c160008741.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c160008741.evolute=true
c160008741.material1=function(mc) return  mc:IsFaceup() and not mc:IsType(TYPE_EFFECT) and mc:GetLevel()==4 or mc:GetRank()==4  end
c160008741.material2=function(mc) return  mc:IsFaceup() and not mc:IsType(TYPE_EFFECT) and mc:GetLevel()==4 or mc:GetRank()==4 end
function c160008741.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c160008741.stage_o=8
c160008741.stage=c160008741.stage_o
end
function c160008741.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if not tc or tc==c or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c160008741.damcon)
	e1:SetOperation(c160008741.damop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c160008741.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return e:GetHandler()==Duel.GetAttacker() and ep~=tp and bc~=nil   and  bc:IsType(TYPE_EFFECT)
end
function c160008741.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c160008741.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c160008741.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,6,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,6,REASON_COST)
end
function c160008741.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()  and c:IsDestructable()
end
function c160008741.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c160008741.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c160008741.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c160008741.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c160008741.atkval(e,c)
	return Duel.GetMatchingGroupCount(c160008741.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil,nil)*100
end
function c160008741.atkfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end