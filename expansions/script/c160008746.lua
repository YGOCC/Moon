--Paintress Warholee
local ref=_G['c'..160008746]
function c160008746.initial_effect(c)
 
	--hand 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c160008746.matcon)
	--e1:SetValue(c160008746.matval)
	e1:SetOperation(ref.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c160008746.ctcon)
	e2:SetOperation(c160008746.ctop)
	c:RegisterEffect(e2)
	   --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160008746,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,160008746)
	e3:SetCost(c160008746.cost)
	e3:SetTarget(c160008746.target)
	e3:SetOperation(c160008746.operation)
	c:RegisterEffect(e3)
end
function c160008746.matcon(c,ec,mode)
	if mode==1 then return Duel.GetFlagEffect(c:GetControler(),160008746)==0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c160008746.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_EFFECT)
end
function c160008746.matval(e,c,mg)
	return c:IsSetCard(0xc50) and mg:IsExists(c160008746.mfilter,1,nil)
end
function ref.matop(c)
	Duel.SendtoGrave(c,REASON_MATERIAL+0x10000000)
end
function c160008746.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c160008746.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,160008746,RESET_PHASE+PHASE_END,0,1)
end

function c160008746.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) or (c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_EFFECT)) and c:IsAbleToRemoveAsCost()
end
function c160008746.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c160008746.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160008746.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160008746.filter(c)
	return  (c:IsSetCard(0xc50) or c:IsSetCard(0xc52)) and c:IsAbleToHand()
end
function c160008746.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c160008746.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c160008746.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160008746.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
