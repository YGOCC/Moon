--Pixie Hesperiidae of Fiber VINE 
function c160002525.initial_effect(c)
		   aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
  aux.AddEvoluteProc(c,nil,6,c160002525.filter1,c160002525.filter1,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(160002525,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c160002525.cost)
	e1:SetTarget(c160002525.target)
	e1:SetOperation(c160002525.operation)
	c:RegisterEffect(e1)
end


function c160002525.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_PLANT)
end

function c160002525.filter(c,e,tp)
	return not  c:IsType(TYPE_EVOLUTE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c160002525.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
		 if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST) end
	e:GetHandler():RemoveEC(tp,4,REASON_COST)
end
function c160002525.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return   Duel.GetLocationCountFromEx(1-tp)>0 and
		 Duel.IsExistingMatchingCard(c160002525.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(c160002525.chlimit)
end
function c160002525.chlimit(e,ep,tp)
	return tp==ep
end
function c160002525.operation(e,tp,eg,ep,ev,re,r,rp)
 if Duel.GetLocationCountFromEx(1-tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160002525.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
	  local e4=e3:Clone()
	e4:SetCode(EVENT_CANNOT_BE_FUSION_MATERIAL)
	tc:RegisterEffect(e4,true)
		  local e5=e3:Clone()
	e4:SetCode(EVENT_CANNOT_BE_XYZ_MATERIAL)
	tc:RegisterEffect(e5,true)
	  local e6=e3:Clone()
	e6:SetCode(EVENT_CANNOT_BE_LINK_MATERIAL)
	tc:RegisterEffect(e6,true)
	  local e7=e3:Clone()
	e7:SetCode(EVENT_CANNOT_BE_EVOLUTE_MATERIAL)
	tc:RegisterEffect(e7,true)
	  local e8=e3:Clone()
	e8:SetCode(EVENT_CANNOT_BE_POLARITY_MATERIAL)
	tc:RegisterEffect(e8,true)
		  local e9=e3:Clone()
	e9:SetCode(EVENT_CANNOT_BE_SPACE_MATERIAL)
	tc:RegisterEffect(e9,true)
		Duel.SpecialSummonComplete()
	end
end
end