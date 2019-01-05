--Hellstrain Reaper
function c212080.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x22f),3,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c212080.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c212080.sprcon)
	e2:SetOperation(c212080.sprop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c212080.atkval)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x22f))
	e4:SetValue(300)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(212080,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLED)
	e5:SetCondition(c212080.damcon)
	e5:SetTarget(c212080.damtg)
	e5:SetOperation(c212080.damop)
	c:RegisterEffect(e5)
	--activate cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCost(c212080.costchk)
	e6:SetOperation(c212080.costop)
	c:RegisterEffect(e6)
end
function c212080.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c212080.spfilter(c)
	return c:IsFusionSetCard(0x22f) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c212080.spfilter1(c,tp,g)
	return g:IsExists(c212080.spfilter2,2,c,tp,c)
end
function c212080.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c212080.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c212080.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:IsExists(c212080.spfilter1,2,nil,tp,g)
end
function c212080.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c212080.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,c212080.spfilter1,2,2,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:FilterSelect(tp,c212080.spfilter2,2,2,mc,tp,mc)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,3,REASON_COST)
end
function c212080.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22f)
end
function c212080.atkval(e,c)
	return Duel.GetMatchingGroupCount(c212080.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c212080.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()
end
function c212080.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetAttackTarget():GetBaseAttack())
end
function c212080.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
	end
end
function c212080.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,212080)
	return Duel.CheckLPCost(tp,ct*300)
end
function c212080.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,300)
end