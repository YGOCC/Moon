--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916167]
local id=28916167
function ref.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(ref.actcost)
	c:RegisterEffect(e1)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1)
	e0:SetCost(ref.cost0)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
end
function ref.ShuffleVs(c)
	return c:IsSetCard(1856) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function ref.SSVs(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(1856) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end

--Activate
function ref.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if ref.cost0(e,tp,eg,ep,ev,re,r,rp,0) and ref.target0(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		ref.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		e:SetTarget(ref.target0)
		e:SetOperation(ref.operation0)
	end
end
--Effect 0
function ref.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.ShuffleVs,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,nil) and e:GetHandler():GetFlagEffect(id)==0 end
	local g0=Duel.SelectMatchingCard(tp,ref.ShuffleVs,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,3,nil)
	if (g0:IsExists(Card.IsLocation,nil,1,LOCATION_HAND)) then
		Duel.ConfirmCards(tp,g0)
	end
	Duel.SendtoDeck(g0,tp,2,REASON_COST)
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,3,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,0)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,3,REASON_EFFECT)~=0 then
		local g2=Duel.GetOperatedGroup()
		if Duel.ConfirmCards(tp,g2)~=0 then
			local g4=g2:Filter(ref.SSVs,nil,e,tp):Select(tp,1,3,nil)
			if Duel.SpecialSummon(g4,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local ssg=g4:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				g2:Sub(ssg)
				local tc=ssg:GetFirst()
				while tc do
					--Duel.RaiseEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
					Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
					tc=ssg:GetNext()
				end
			end
			Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
		end
	end
end
