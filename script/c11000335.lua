--Headhunters Net
function c11000335.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c11000335.shcon)
	e1:SetTarget(c11000335.target)
	e1:SetOperation(c11000335.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetCondition(c11000335.shcon)
	e2:SetTarget(c11000335.target)
	e2:SetOperation(c11000335.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11000335.shcon)
	e3:SetTarget(c11000335.target2)
	e3:SetOperation(c11000335.activate2)
	c:RegisterEffect(e3)
end
function c11000335.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1FF)
end
function c11000335.shcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11000335.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c11000335.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
		and ep~=tp and c:IsDestructable()
end
function c11000335.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c11000335.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c11000335.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11000335.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then return end
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c11000335.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp
		and c:IsDestructable()
end
function c11000335.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11000335.filter2,1,nil,tp) end
	local g=eg:Filter(c11000335.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11000335.filter3(c,e,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsDestructable()
end
function c11000335.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11000335.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then return end
	local g=eg:Filter(c11000335.filter3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
