--Sharpshooter of Discord, Primal Marksman
function c60000627.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Primal Summon
	if not c60000627.global_check then
		c60000627.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetLabel(550)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c60000627.chk)
		Duel.RegisterEffect(ge1,0)
	end
    --double attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c60000627.atkcon)
    e1:SetTarget(c60000627.atkfil)
    e1:SetValue(c60000627.atkop)
    c:RegisterEffect(e1)
    --slow scale effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c60000627.destrg)
	e2:SetOperation(c60000627.desop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c60000627.pencon)
	e3:SetTarget(c60000627.pentg)
	e3:SetOperation(c60000627.penop)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c60000627.imfil)
	e5:SetCondition(c60000627.imcon)
	c:RegisterEffect(e5)
	--triple swing
	local e6=Effect.CreateEffect(c)
	c:RegisterEffect(e6)
end
c60000627.primal=true
c60000627.material=function(mc) return mc:IsLevelAbove(5) or mc:IsRankAbove(5) --[[or mc:IsPrimeLevelAbove(5)]] --[[Uncomment this filter when custom Percy has Prime Levels added]] end
function c60000627.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c60000627.atkfil(e,c)
	return c:IsFaceup() and c:IsLevelAbove(5) or c:IsRankAbove(5) --[[or c:IsPrimeLevelAbove(5)]] --[[Uncomment this filter when custom Percy has Prime Levels added]]
end
function c60000627.atkop(e,c)
    return c:GetAttack()*2
end
function c60000627.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    local tp=Duel.GetTurnPlayer()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c60000627.destrg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c60000627.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e) or Duel.Destroy(g,REASON_EFFECT)~=2 then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetValue(2)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)
end
function c60000627.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c60000627.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60000627.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000627.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c60000627.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60000627.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60000627.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c60000627.imfil(e,te)
    return te:IsActiveType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c60000627.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return c:IsStatus(STATUS_SPSUMMON_TURN) and bit.band(c:GetSummonType(),0x5500)==0x5500
end
