function c353719489.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c353719489.activate)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c353719489.aclimit)
	e2:SetCondition(c353719489.actcon)
	c:RegisterEffect(e2)
			--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c353719489.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end	
function c353719489.tglimit(e,c)
	return c:IsSetCard(0x21ca) and c~=e:GetHandler()
	end
function c353719489.thfilter(c)
	return c:IsSetCard(0x21c) or c:IsSetCard(0x21ca) and c:IsAbleToHand()
end
function c353719489.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c353719489.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c353719489.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c353719489.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(353719489,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c353719489.aclimit(e,re,tp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and not re:GetHandler():IsImmuneToEffect(e)
end
function c353719489.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	return a and a:IsSetCard(0x21c) and a:IsControler(tp)
end
