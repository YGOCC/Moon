--Silver Skull of the Lightning
--Script by XGlitchy30
function c37200223.initial_effect(c)
	c:SetUniqueOnField(1,0,37200223)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--change position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200223,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c37200223.postg)
	e1:SetOperation(c37200223.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--random control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200223,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37200223.ctcost)
	e3:SetTarget(c37200223.cttg)
	e3:SetOperation(c37200223.ctop)
	c:RegisterEffect(e3)
	--negate attack/change position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200223,2))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(c37200223.attg)
	e4:SetOperation(c37200223.atop)
	c:RegisterEffect(e4)
end
--filters
function c37200223.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c37200223.costfilter(c)
	return (c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_MZONE))
		or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_HAND))
end
function c37200223.rcfilter(c)
	return c:IsFacedown() and c:IsControlerCanBeChanged()
end
function c37200223.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
--change position
function c37200223.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200223.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c37200223.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c37200223.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c37200223.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
--random control
function c37200223.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200223.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c37200223.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end
function c37200223.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200223.rcfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,LOCATION_MZONE)
end
function c37200223.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c37200223.rcfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	local tc=sg:GetFirst()
	if Duel.GetControl(sg,tp)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_FLIP)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTarget(c37200223.fliptg)
		e1:SetOperation(c37200223.flipop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
--gain ATK
function c37200223.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c37200223.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c37200223.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c37200223.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=e:GetHandler():GetBaseAttack()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--negate attack
function c37200223.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler()
		and d~=nil and d:IsFaceup() and not d:IsAttribute(ATTRIBUTE_DARK) and d:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function c37200223.atop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and d:IsFaceup() and not d:IsAttribute(ATTRIBUTE_DARK)
	and Duel.NegateAttack()~=0 then
		Duel.ChangePosition(d,POS_FACEDOWN_DEFENSE)
	end
end
