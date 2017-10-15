--Reapers' Hex
function c31880016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c31880016.condition)
	e1:SetCost(c31880016.cost)
	e1:SetTarget(c31880016.target)
	e1:SetOperation(c31880016.activate)
	c:RegisterEffect(e1)
end
function c31880016.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsControler(1-tp)
end
function c31880016.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7C88)
end
function c31880016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c31880016.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c31880016.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c31880016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:GetFirst():IsCanBeEffectTarget(e) and eg:GetFirst():IsControlerCanBeChanged() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function c31880016.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,0,0) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end