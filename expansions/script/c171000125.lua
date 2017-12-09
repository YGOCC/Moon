--Impure Amethyst
local ref=_G['c'..171000125]
function c171000125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,171000125+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_PZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_PZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_COST)
	e:SetLabel(ct)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
		or Duel.IsExistingMatchingCard(ref.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,0)
end
function ref.thfilter1(c)
	return c:IsSetCard(0xfef) and c:IsType(TYPE_MONSTER) 
		and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function ref.thfilter2(c)
	return c:IsType(TYPE_SPELL) and not c:IsCode(171000125) and c:IsAbleToHand()
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then return end
	local opt=0
	local b1=Duel.IsExistingMatchingCard(ref.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(ref.thfilter2,tp,LOCATION_GRAVE,0,1,nil)
	if ct==2 then 
		if b1 and b2 then
			opt=Duel.SelectOption(tp,aux.Stringid(171000125,0),aux.Stringid(171000125,1))
		elseif b1 then
			opt=0
		elseif b2 then
			opt=1
		else return 
		end
	elseif ct==1 or ct>2 then
		opt=0
	else return
	end
	if opt==0 then
		local sg=Duel.SelectMatchingCard(tp,ref.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif opt==1 then
			local sg=Duel.SelectMatchingCard(tp,ref.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
	else return end
end 