--Sphreez, Sphere of Gust Vine
function c160008517.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,500316001,aux.FilterBoolFunction(c160008517.ffilter),1,true,true)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160008517,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,160008517)
	e1:SetCondition(c160008517.thcon)
	e1:SetTarget(c160008517.thop)
	e1:SetOperation(c160008517.thop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160008517,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c160008517.retcon)
	e2:SetTarget(c160008517.rettg)
	e2:SetOperation(c160008517.retop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160008517,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,160008517)
	e3:SetCost(c160008517.tdcost)
	e3:SetTarget(c160008517.tdtg)
	e3:SetOperation(c160008517.tdop)
	c:RegisterEffect(e3)
end
function c160008517.ffilter(c)
	return  c:GetLevel()<=4 and c:GetCode()~=160008517  and c:GetLevel()>0  or c:IsHasEffect(500317451)
end
function c160008517.thcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION or e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION+0x786
end
function c160008517.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c160008517.gvfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c160008517.gvfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c160008517.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c160008517.cfilter(c)
	return c:IsSetCard(0x885a)   and c:IsAbleToRemoveAsCost()
end
function c160008517.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return Duel.IsExistingMatchingCard(c160008517.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c160008517.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c160008517.tdfilter(c)
 return bit.band(c:GetOriginalType(),TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ)~=0
end
function c160008517.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c160008517.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc   and tc:IsAbleToDeck() then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
			if tc:IsFaceup() and tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,nil) then
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,nil)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		end
	end
end
function c160008517.tdop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		if tc:IsLocation(LOCATION_EXTRA) and tc:IsType(TYPE_XYZ) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
end
function c160008517.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()~=tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c160008517.gvfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x885a)
end
function c160008517.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c160008517.gvfilter,tp,LOCATION_REMOVED,0,1,nil)    end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(160008517,0))
	local g=Duel.SelectTarget(tp,c160008517.gvfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	
	
end
function c160008517.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
local tc=Duel.GetFirstTarget()
if tc and tc:IsRelateToEffect(e) and  g:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(160008517,3)))then
Duel.SendtoGrave(tc,nil,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end

	end

