--Paradox Dragon
--Design and Code by Kindrindra
local ref=_G['c'..28915049]
function ref.initial_effect(c)
	--SpSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Reorder
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915049,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(ref.condition)
	e2:SetTarget(ref.sttg)
	e2:SetOperation(ref.stop)
	c:RegisterEffect(e2)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,28915049)
	e5:SetCondition(aux.exccon)
	e5:SetCost(ref.sscost)
	e5:SetTarget(ref.sstg)
	e5:SetOperation(ref.ssop)
	c:RegisterEffect(e5)
end
function ref.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_DARK)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_DARK)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function ref.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_TRAP) end
end
function ref.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_TRAP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g3=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP)
		g1:Merge(g2)
		g1:Merge(g3)
		Duel.ConfirmCards(1-tp,g1)
		local tc=g1:GetFirst()
		while tc do
			Duel.MoveSequence(tc,0)
			tc=g1:GetNext()
		end
		Duel.SortDecktop(tp,tp,3)
	end
end

function ref.sscfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function ref.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.sscfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.sscfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function ref.ssfilter(c,e,tp)
	return c:IsCode(18631392) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
