--Tera Junior the Game Master
function c12000239.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x856),2)
	c:EnableReviveLimit()
	--Tribute and take
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000239,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12000239)
	e1:SetTarget(c12000239.cttg)
	e1:SetOperation(c12000239.ctop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000239,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12000239.damtg)
	e2:SetOperation(c12000239.damop)
	c:RegisterEffect(e2)
end
function c12000239.cfilter2(c,lg,lv)
	return c:IsType(TYPE_MONSTER) and lg:IsContains(c)
		and c:IsLevelBelow(lv) or c:IsRankBelow(lv)
end
function c12000239.cfilter1(c,lg)
	return lg:IsContains(c) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c12000239.cfilter2,tp,0,LOCATION_MZONE,1,nil,lg,c:GetLevel())
end
function c12000239.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c12000239.cfilter1,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c12000239.ctop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local lv=0
	local g1=Duel.SelectReleaseGroup(tp,c12000239.cfilter1,1,1,nil,lg)
	local tc=g1:GetFirst()
	local lv=tc:GetLevel()
	if Duel.Release(tc,REASON_EFFECT)~=0 then
		local g2=Duel.SelectMatchingCard(tp,c12000239.cfilter2,tp,0,LOCATION_MZONE,1,1,nil,lg,lv)
		if g2:GetCount()>0 then
			Duel.GetControl(g2,tp,PHASE_END,1)
		end
	end
end
function c12000239.damfilter(c,tp)
	return c:GetOwner()==tp and c:GetAttack()>0
end
function c12000239.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000239.damfilter,tp,LOCATION_MZONE,0,1,nil,1-tp) end
	local g=Duel.GetMatchingGroup(c12000239.damfilter,tp,LOCATION_MZONE,0,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12000239.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c12000239.damfilter,tp,LOCATION_MZONE,0,1,1,nil,1-tp)
	local tc=g:GetFirst()
	local dam=tc:GetAttack()
	if tc:GetAttack() < tc:GetDefense() then dam=tc:GetDefense() end
	if dam<0 then dam=0 end
	Duel.HintSelection(tc)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
