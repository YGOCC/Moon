--Abyss Actor - Queen of Style
--scripted by Rawstone
local s,id=GetID()
function s.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.chcon1)
	e1:SetOperation(s.chop1)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(s.cond)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.cond)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCountLimit(1,id+100)
	e4:SetCondition(s.chcon4)
	e4:SetOperation(s.chop2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.teop)
	c:RegisterEffect(e5)
end
	function s.name(c,e)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
	function s.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return  ep~=tp
	and Duel.IsExistingMatchingCard(s.confilter1,tp,LOCATION_MZONE,0,1,nil)
	and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetSummonLocation()==LOCATION_EXTRA 
end
	function s.chop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
	function s.confilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
	function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
	function s.indfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:IsLevelAbove(7) and c:IsType(TYPE_PENDULUM)
end
	function s.cond(e)
	return Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
	 function s.chcon4(e,tp,eg,ep,ev,re,r,rp)
	return  ep~=tp
	and Duel.IsExistingMatchingCard(s.confilter1,tp,LOCATION_MZONE,0,1,nil)
	and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
	function s.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
	function s.desfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
	function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
	function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
	function s.filter(c)
	return c:IsSetCard(0x10ec) and c:IsAbleToExtra() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
	function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
	function s.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end