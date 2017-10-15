--Variachrome Halo
function c249000583.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000583.target)
	e1:SetOperation(c249000583.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(0x1D3)
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
	--lpcost replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85668449,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_LPCOST_REPLACE)
	e3:SetCondition(c249000583.lrcon)
	e3:SetOperation(c249000583.lrop)
	c:RegisterEffect(e3)
end
function c249000583.filter(c)
	return c:IsSetCard(0x1D3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c249000583.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000583.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000583.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000583.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000583.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep or (not e:GetHandler():IsAbleToRemoveAsCost()) then return false end
	if not re or not re:IsHasType(0x7e0) then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x1D3)
end
function c249000583.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Recover(tp,ev,REASON_COST)
end