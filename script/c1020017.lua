--Galactic Codeman: Scale Zero
function c1020017.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1020017,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c1020017.spcost)
	e2:SetTarget(c1020017.sptg)
	e2:SetCountLimit(1,1020017+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c1020017.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c1020017.discon)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(c1020017.distg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(c1020017.discon)
	e4:SetRange(LOCATION_PZONE)
	e4:SetOperation(c1020017.disop)
	c:RegisterEffect(e4)
	--ATK
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(aux.bdocon)
	e5:SetTarget(c1020017.target)
	e5:SetCountLimit(1)
	e5:SetOperation(c1020017.operation)
	c:RegisterEffect(e5)
end
function c1020017.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1020017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020017.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1020017.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1020017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1020017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c1020017.disfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER)
end
function c1020017.discon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1020017.disfilter,tp,LOCATION_ONFIELD,0,1,nil) then return true end
end
function c1020017.distg(e,c)
	return c:IsType(TYPE_SPELL) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c1020017.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:IsActiveType(TYPE_SPELL) and p~=tp and loc==LOCATION_SZONE and (seq==6 or seq==7) then
		Duel.NegateEffect(ev)
	end
end
function c1020017.atkfilter(c)
	return c:IsFaceup()
end
function c1020017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1020017.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1020017.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1020017.atkfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c1020017.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
