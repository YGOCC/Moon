--Cupillar of Fiber VINE
function c16000129.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c16000129.spcost)
	e1:SetCondition(c16000129.spcon)
	c:RegisterEffect(e1) 
		--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000129,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(2,16000129)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c16000129.spcost)
	e2:SetTarget(c16000129.target)
	e2:SetOperation(c16000129.operation)
	c:RegisterEffect(e2)
 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16000129,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c16000129.target2)
	e3:SetOperation(c16000129.activate2)
	c:RegisterEffect(e3)
 Duel.AddCustomActivityCounter(16000129,ACTIVITY_SPSUMMON,c16000129.counterfilter)
end

function c16000129.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16000129,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16000129.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c16000129.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x85a)
end

function c16000129.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
-- SpecialSummon from hand
function c16000129.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x185a) or  c:IsCode(16000129)
end
function c16000129.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return   Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c16000129.cfilter,tp,LOCATION_MZONE,0,1,nil))
end

function c16000129.filter(c,e,sp)
	return c:IsSetCard(0x185a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c16000129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000129.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16000129.operation(e,tp,eg,ep,ev,re,r,rp)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16000129.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c16000129.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x185a) and (c:IsType(TYPE_EVOLUTE) or c:IsType(TYPE_RITUAL) )
end
function c16000129.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16000129.filter2(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(c16000129.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16000129.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	  --  local e2=Effect.CreateEffect(e:GetHandler())
	  --  e2:SetType(EFFECT_TYPE_SINGLE)
	  --  e2:SetCode(EFFECT_PIERCE)
	  --  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	  --  tc:RegisterEffect(e2)
	end
end
