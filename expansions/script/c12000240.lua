--Tera Minor the Game Master
function c12000240.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x856),2)
	c:EnableReviveLimit()
	--Tribute and take
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000240,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12000240)
	e1:SetTarget(c12000240.cttg)
	e1:SetOperation(c12000240.ctop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000240,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12000240.negcon)
	e2:SetCost(c12000240.negcost)
	e2:SetTarget(c12000240.negtg)
	e2:SetOperation(c12000240.negop)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c12000240.lvtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c12000240.cfilter2(c,lg,lv)
	return c:IsType(TYPE_MONSTER) and lg:IsContains(c)
		and (c:IsLevelBelow(lv) or c:IsRankBelow(lv))
end
function c12000240.cfilter1(c,lg)
	return lg:IsContains(c) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c12000240.cfilter2,tp,0,LOCATION_MZONE,1,nil,lg,c:GetLevel())
end
function c12000240.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c12000240.cfilter1,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c12000240.ctop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local lv=0
	local g1=Duel.SelectReleaseGroup(tp,c12000240.cfilter1,1,1,nil,lg)
	local tc=g1:GetFirst()
	local lv=tc:GetLevel()
	if Duel.Release(tc,REASON_EFFECT)~=0 then
		local g2=Duel.SelectMatchingCard(tp,c12000240.cfilter2,tp,0,LOCATION_MZONE,1,1,nil,lg,lv)
		if g2:GetCount()>0 then
			Duel.GetControl(g2,tp,PHASE_END,1)
		end
	end
end
function c12000240.negcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c12000240.negfilter(c,tp)
	return c:GetOwner()==tp
end
function c12000240.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12000240.negfilter,1,nil,1-tp) end
	local g=Duel.SelectReleaseGroup(tp,c12000240.negfilter,1,1,nil,1-tp)
	Duel.Release(g,REASON_COST)
end
function c12000240.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c12000240.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
function c12000240.lvtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
		and c:IsSetCard(0x856)
end
