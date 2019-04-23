--Paintress Dragon
function c160008741.initial_effect(c)
   aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
  aux.AddEvoluteProc(c,nil,8,c160008741.filter1,c160008741.filter2,2,99)
	--destroy
   --todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160008741,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,160008741)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCost(c160008741.cost)
	e1:SetTarget(c160008741.target)
	e1:SetOperation(c160008741.operation)
	c:RegisterEffect(e1)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c160008741.atkval)
	c:RegisterEffect(e4)
 end
--filters
function c160008741.filter1(c,ec,tp)
	return  c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY)
end
function c160008741.filter2(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) 
end
function c160008741.costfilter(c,tp)
	return c:IsSetCard(0xc50) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) 
		and (c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()))
		and Duel.IsExistingTarget(c160008741.filter,tp,LOCATION_REMOVED,0,1,c,nil,tp)
end
function c160008741.filter(c,exc,tp)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and (not exc or not exc:IsContains(c))
		and Duel.IsExistingMatchingCard(c160008741.filterc,tp,0,LOCATION_MZONE,1,nil)
end
function c160008741.filterc(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToHand() and c:IsFaceup()
end
--todeck
function c160008741.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c160008741.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exc=e:GetLabelObject()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c160008741.filter(chkc,nil,tp) end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c160008741.costfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,nil,tp) 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160008741.costfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,nil,tp)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_COST)~=0 then
			local exc=Duel.GetOperatedGroup()
			exc:KeepAlive()
			e:SetLabelObject(exc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectTarget(tp,c160008741.filter,tp,LOCATION_REMOVED,0,1,3,nil,e:GetLabelObject(),tp)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_MZONE)
		end
	end
end
function c160008741.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			local chkshuffle=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			local dg=Duel.GetMatchingGroup(c160008741.filterc,tp,0,LOCATION_MZONE,nil)
			if ct>0 and dg:GetCount()>0 then
				if chkshuffle>0 then
					Duel.ShuffleDeck(tp)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
				local rg=dg:Select(tp,1,ct,nil)
				Duel.HintSelection(rg)
				Duel.SendtoHand(rg,nil,REASON_EFFECT)
			end
		end
	end
	e:GetLabelObject():DeleteGroup()
end



function c160008741.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsType,nil,TYPE_NORMAL)
	e:GetLabelObject():SetLabel(ct)
end
function c160008741.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST)  end
e:GetHandler():RemoveEC(tp,4,REASON_COST)
end
function c160008741.atkval(e,c)
	return Duel.GetMatchingGroupCount(c160008741.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil,nil)*100
end
function c160008741.atkfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end