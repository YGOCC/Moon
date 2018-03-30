--Maestro della Spada Fiammante
--Script by XGlitchy30
function c37200268.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c37200268.sprcon)
	e1:SetOperation(c37200268.sprop)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c37200268.sumop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200268,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c37200268.drytg)
	e4:SetOperation(c37200268.dryop)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c37200268.aclimit)
	e5:SetCondition(c37200268.actcon)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(37200268,1))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetTarget(c37200268.dgtg)
	e6:SetOperation(c37200268.dgop)
	c:RegisterEffect(e6)
	--multi atk
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(37200268,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c37200268.atcon)
	e7:SetCost(c37200268.atcost)
	e7:SetTarget(c37200268.attg)
	e7:SetOperation(c37200268.atop)
	c:RegisterEffect(e7)
end
--filters
function c37200268.sprfilter(c,tp)
	local eq=c:GetEquipGroup()
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c37200268.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,eq)
end
function c37200268.eqfilter(c,g)
	return c:IsFaceup() and c:IsCode(32268901) and g:IsContains(c)
end
function c37200268.dryfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c37200268.atfilter(c)
	return c:IsCode(32268901) and c:IsAbleToRemoveAsCost()
end
--spsummon procedure
function c37200268.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c37200268.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c37200268.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c37200268.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
--spsummon success
function c37200268.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) then return end
	Duel.SetChainLimitTillChainEnd(c37200268.chainlm)
end
function c37200268.chainlm(e,rp,tp)
	return tp==rp
end
--destroy all
function c37200268.drytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c37200268.dryfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c37200268.dryop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c37200268.dryfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--actlimit
function c37200268.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c37200268.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
--damage
function c37200268.dgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1800)
end
function c37200268.dgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--multi attack
function c37200268.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and Duel.IsAbleToEnterBP()
end
function c37200268.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200268.atfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c37200268.atfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c37200268.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c37200268.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end