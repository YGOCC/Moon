--coded by Lyris
--Steelus Incarnatem
function c192051213.initial_effect(c)
	c:EnableReviveLimit()
	--2 "Steelus" monsters
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x617),2,true)
	--When this card is Fusion Summoned: You can banish up to 3 "Steelus" monsters from your GY; send cards with different names from your opponent's Extra Deck to the GY equal to the number of monsters you banished to activate this effect, then draw 1 card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetCondition(c192051213.tgcon)
	e1:SetCost(c192051213.cost)
	e1:SetTarget(c192051213.tgtg)
	e1:SetOperation(c192051213.tgop)
	c:RegisterEffect(e1)
end
function c192051213.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c192051213.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x617) and c:IsAbleToRemoveAsCost()
end
function c192051213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c192051213.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c192051213.cfilter,tp,LOCATION_GRAVE,0,1,math.min(Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA),3),nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c192051213.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c192051213.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,tg)
	if tg:GetClassCount(Card.GetCode)>=ct then
		local rg=Group.CreateGroup()
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc then
				rg:AddCard(tc)
				tg:Remove(Card.IsCode,nil,tc:GetCode())
			end
		end
		Duel.SendtoGrave(rg,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		if dg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==ct then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
