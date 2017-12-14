--Great Entrance of the Fortress

function c30039213.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c30039213.target1)
	e1:SetOperation(c30039213.operation)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c30039213.cost2)
	e2:SetTarget(c30039213.target2)
	e2:SetOperation(c30039213.operation)
	c:RegisterEffect(e2)
	
	--attack directly
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c30039213.dirtg)
	c:RegisterEffect(e3)
	end
	
	function c30039213.filter1(c,e,tp)
	return (c:IsCode(87796900) or c:IsCode(57405307) or c:IsSetCard(0xE4)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
	
function c30039213.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c30039213.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	local op=2
	e:SetCategory(0)
	if Duel.GetFlagEffect(tp,30039213)==0 and (b1) and Duel.SelectYesNo(tp,aux.Stringid(30039213,0)) then
		if b1 then op=0 end
		if op==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)

		end
		Duel.RegisterFlagEffect(tp,30039213,RESET_PHASE+PHASE_END,0,1)
	end
	e:SetLabel(op)
end

function c30039213.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c30039213.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c30039213.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,30039213)==0 end
	Duel.RegisterFlagEffect(tp,30039213,RESET_PHASE+PHASE_END,0,1)
end

function c30039213.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c30039213.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	
	if chk==0 then return b1 end
	local op=0

	e:SetLabel(op)

	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	
	end
end


function c30039213.dirtg(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c) and not c:IsImmuneToEffect(e)
end