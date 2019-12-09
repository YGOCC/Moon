--Paintress Amersterdima
function c160009999.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	  --cannot be target/indestructable
   -- local e2=Effect.CreateEffect(c)
  --  e2:SetType(EFFECT_TYPE_FIELD)
 --   e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  --  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
 --   e2:SetRange(LOCATION_PZONE)
  --  e2:SetTargetRange(LOCATION_ONFIELD,0)
  --  e2:SetTarget(c160009999.tgtg)
  --  e2:SetValue(aux.tgoval)
 --   c:RegisterEffect(e2)
 --   local e3=e2:Clone()
 --   e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
 --   e3:SetValue(aux.indoval)
 --   c:RegisterEffect(e3)
	--actlimit
--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160009999,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,160009999)
	e4:SetCondition(c160009999.thcon)
	e4:SetTarget(c160009999.target)
	e4:SetOperation(c160009999.operation)
	c:RegisterEffect(e4)
end

function c160009999.tgtg(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function c160009999.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.IsExistingMatchingCard(c160009999.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c160009999.costfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Release(g,REASON_COST)
end

function c160009999.costfilter(c)
	return  c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end

function c160009999.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return  c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and (c:GetSequence()==0 or c:GetSequence()==4) end,tp,LOCATION_SZONE,0,1,e:GetHandler())
end

function c160009999.filter(c,e,tp)
	return (c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c160009999.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c160009999.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c160009999.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160009999.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c160009999.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()

end
