--Samid, Seed of Fiber Vine
function c500311994.initial_effect(c)
	--ATK & DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(c500311994.tg1)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(c500311994.tg2)
	e2:SetValue(-400)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500311994,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,500311994)
	e3:SetCost(c500311994.thcost)
	e3:SetTarget(c500311994.thtg)
	e3:SetOperation(c500311994.thop)
	c:RegisterEffect(e3)
	--ritual material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c500311994.tg1(e,c)
	return c:IsSetCard(0x185a)
end
function c500311994.tg2(e,c)
	return not c:IsSetCard(0x185a)
end
function c500311994.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c500311994.thfilter(c)
	return c:IsSetCard(0x185a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c500311994.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(c500311994.cfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c500311994.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500311994.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local rg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				rg:AddCard(tc)
				g:Remove(Card.IsCode,nil,tc:GetCode())
			end
		end
		Duel.ConfirmCards(1-tp,rg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=rg:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end