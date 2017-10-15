--Black Flag Captain
function c90000088.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c90000088.scondition)
	e1:SetOperation(c90000088.soperation)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--Set Summon
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--Summon Condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.penlimit)
	c:RegisterEffect(e3)
	--Tribute Condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIBUTE_LIMIT)
	e4:SetValue(c90000088.value)
	c:RegisterEffect(e4)
	--Scale Change
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c90000088.condition)
	e5:SetTarget(c90000088.target)
	e5:SetOperation(c90000088.operation)
	c:RegisterEffect(e5)
	--Destroy Equip
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_EQUIP)
	e6:SetTarget(c90000088.target2)
	e6:SetOperation(c90000088.operation2)
	c:RegisterEffect(e6)
	--ATK Up
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c90000088.target3)
	e7:SetOperation(c90000088.operation3)
	c:RegisterEffect(e7)
	--Chain Attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLED)
	e8:SetCondition(c90000088.condition2)
	e8:SetOperation(c90000088.operation4)
	c:RegisterEffect(e8)
end
function c90000088.scondition(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3
end
function c90000088.soperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c90000088.value(e,c)
	return not c:IsType(TYPE_PENDULUM)
end
function c90000088.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90000088.filter(c,lv)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(lv)
end
function c90000088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local scl=math.max(1,e:GetHandler():GetLeftScale()-3)
	local g=Duel.GetMatchingGroup(c90000088.filter,tp,LOCATION_MZONE,0,nil,scl)
	if e:GetHandler():GetLeftScale()>1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c90000088.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()==1 then return end
	local scl=3
	if c:GetLeftScale()==3 then scl=2 end
	if c:GetLeftScale()==2 then scl=1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-scl)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	local g=Duel.GetMatchingGroup(c90000088.filter,tp,LOCATION_MZONE,0,nil,c:GetLeftScale())
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c90000088.filter2(c,ec)
	return c:GetEquipTarget()==ec
end
function c90000088.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000088.filter2,1,nil,e:GetHandler()) end
	local dg=eg:Filter(c90000088.filter2,nil,e:GetHandler())
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c90000088.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(tg,REASON_EFFECT)
end
function c90000088.filter3(c,e,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsRace(RACE_ZOMBIE) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
end
function c90000088.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000088.filter3,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c90000088.filter3,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c90000088.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c90000088.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c90000088.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end