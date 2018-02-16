function c353719800.initial_effect(c) 
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,353719800)
	e1:SetOperation(c353719800.activate)
	c:RegisterEffect(e1)
	--cannot attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c353719800.antarget)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    c:RegisterEffect(e3)
    --search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(353719800,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c353719800.thcon)
	e4:SetTarget(c353719800.target2)
	e4:SetOperation(c353719800.activate2)
	c:RegisterEffect(e4)
Duel.AddCustomActivityCounter(353719800,ACTIVITY_SPSUMMON,c353719800.counterfilter)
end
	function c353719800.counterfilter(c)
	return c:IsSetCard(0x10f3)
end
	function c353719800.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10f3) and c:IsAbleToHand()
end
function c353719800.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c353719800.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(35371948,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c353719800.antarget(e,c)
    return c~=e:GetHandler() and c:GetCounter(0x1041)~=0
end
function c353719800.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetCounter(0x1041)>0
end
function c353719800.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c353719800.cfilter,1,nil)
end
function c353719800.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c353719800.activate2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
