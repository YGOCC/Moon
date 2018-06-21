--Paintress' Sketchbook
function c160008952.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c160008952.target)
	e1:SetOperation(c160008952.activate)
	c:RegisterEffect(e1)
   local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160008952,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
   -- e2:SetCountLimit(1,50031787)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c160008952.target1)
	e2:SetOperation(c160008952.activate69)
	c:RegisterEffect(e2)
end
function c160008952.filter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsFaceup()  and c:IsType(TYPE_MONSTER) or (not c:IsType(TYPE_EFFECT)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160008952.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c160008952.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c160008952.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160008952.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c160008952.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c160008952.kfilter(c)
	return  c:GetSummonLocation()==LOCATION_EXTRA 
end
function c160008952.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c160008952.kfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160008952.kfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(160008952,0))
	Duel.SelectTarget(tp,c160008952.kfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c160008952.activate69(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
