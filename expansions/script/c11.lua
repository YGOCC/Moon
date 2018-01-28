--tomoe
function c11.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCondition(c11.spcon)
	e2:SetOperation(c11.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11.condition)
	e3:SetOperation(c11.operation)
	c:RegisterEffect(e3)
end
function c11.spfilter1(c,mg)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	return c:IsFusionSetCard(0x159) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c11.spfilter2,1,nil,mg2)
end
function c11.spfilter2(c,mg)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	return c:IsFusionSetCard(0x159) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c11.spfilter3,1,nil)
end
function c11.spfilter3(c)
	return c:IsFusionSetCard(0x159) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c11.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsFusionSetCard,tp,LOCATION_MZONE,0,nil,0x159)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and mg:IsExists(c11.spfilter1,1,nil,mg)
end
function c11.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsFusionSetCard,tp,LOCATION_MZONE,0,nil,0x159)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=mg:FilterSelect(tp,c11.spfilter1,1,1,nil,mg)
	mg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=mg:FilterSelect(tp,c11.spfilter2,1,1,nil,mg)
	mg:RemoveCard(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=mg:FilterSelect(tp,c11.spfilter3,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c11.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c11.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11.discon)
	e1:SetCost(c11.discost)
	e1:SetTarget(c11.distg)
	e1:SetOperation(c11.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
function c11.discon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c11.filter(c)
	return c:IsSetCard(0x159) and c:IsAbleToRemoveAsCost()
end
function c11.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
