--Mystical Elf: Helena
--Script by XGlitchy30
function c76253941.initial_effect(c)
	--spsum proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76253941.spcon)
	e1:SetOperation(c76253941.spop)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76253941,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,76253941)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c76253941.lptg)
	e2:SetOperation(c76253941.lpop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(76253941,ACTIVITY_SPSUMMON,c76253941.counterfilter)
end
--filters
function c76253941.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c76253941.spfilter(c)
	return c:IsType(TYPE_SPELL)
end
function c76253941.lpfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7634) and c:GetAttack()>0
end
--values
function c76253941.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end
--spsum proc
function c76253941.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetCustomActivityCount(76253941,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c76253941.spfilter,tp,LOCATION_HAND,0,1,nil)
end
function c76253941.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c76253941.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
	--spsum limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76253941.splimit)
	Duel.RegisterEffect(e1,tp)
end
--banish
function c76253941.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c76253941.lpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76253941.lpfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c76253941.lpfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c76253941.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
	end
end