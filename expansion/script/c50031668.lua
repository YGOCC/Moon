--Supa-Paintress Disfguring Bacouzu
--Created by Chadook
--Scripted by Chadook
function c50031668.initial_effect(c)
--synchro summon
	
	c:EnableReviveLimit()
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50031668,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c50031668.eqcost)
	e1:SetTarget(c50031668.target)
	e1:SetOperation(c50031668.operation)
	c:RegisterEffect(e1)
		--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50031668,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c50031668.spcon)
	e2:SetTarget(c50031668.sptg)
	e2:SetOperation(c50031668.spop)
	c:RegisterEffect(e2)
		if not c50031668.global_check then
		c50031668.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c50031668.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c50031668.evolute=true
c50031668.material1=function(mc) return mc:IsCode(160001123) and mc:IsFaceup() end
c50031668.material2=function(mc) return mc:IsType(TYPE_NORMAL) and mc:GetLevel()==4 and mc:IsFaceup() end
function c50031668.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c50031668.stage_o=5
c50031668.stage=c50031668.stage_o
end
function c50031668.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,2,REASON_COST)
end

function c50031668.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(50031668,1))
	else op=Duel.SelectOption(tp,aux.Stringid(50031668,1),aux.Stringid(50031668,2)) end
	e:SetLabel(op)
end
function c50031668.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if e:GetLabel()==0 then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		else Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)end
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end	
	end
function c50031668.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) 
end
function c50031668.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50031668.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50031668.spop(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50031668.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0  then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c50031668.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc50) and c:IsFaceup()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end