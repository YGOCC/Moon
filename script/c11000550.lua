--Ahri, the Nine tailed Fox
function c11000550.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1FE))
	e2:SetValue(c11000550.valcon)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11000550.efilter)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--def up
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--indes self
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Own Special Summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c11000550.spcon)
	e6:SetOperation(c11000550.spop)
	c:RegisterEffect(e6)
	--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetCost(c11000550.cost)
	e7:SetTarget(c11000550.target)
	e7:SetOperation(c11000550.activate)
	c:RegisterEffect(e7)
end
function c11000550.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c11000550.efilter(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c11000550.rfilter(c)
	return c:IsSetCard(0x1FE) and c:IsType(TYPE_NORMAL)
end
function c11000550.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c11000550.rfilter,1,nil)
end
function c11000550.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c11000550.rfilter,1,1,nil)
	if Duel.Release(g,REASON_COST) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c11000550.cfilter(c,tp)
	return c:IsSetCard(0x1FE) and (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c11000550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11000550.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c11000550.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c11000550.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c11000550.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,0,0) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
