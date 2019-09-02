--created & coded by Lyris, art by dsorokin755 of DeviantArt
--ニュートリックス・ナイトクラッブ
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd10))
	e2:SetValue(function(e,tc) local tp=e:GetHandlerPlayer() return Duel.GetMatchingGroupCount(cid.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)*300 end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cid.condition)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) local p,tg=Duel.GetTurnPlayer(),Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,p,LOCATION_MZONE,0,1,tg,TYPE_LINK) end end)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
end
function cid.filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd10) and c:IsAbleToHand()
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFlagEffect(tp,id)~=0 then return end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function cid.lfilter(c,tp)
	return Duel.IsExistingMatchingCard(function(tc,lpt) return tc:GetLinkMarker()&lpt>0 end,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLinkMarker())
		or (c:IsType(TYPE_LINK) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,TYPE_LINK))
end
function cid.cfilter(c)
	return c:IsOnField() and c:IsType(TYPE_LINK)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not re:IsHasType(EFFECT_TYPE_QUICK_O) or not re:GetHandler():IsSetCard(0xd10) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cid.cfilter,1,nil)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,g=Duel.GetTurnPlayer(),Duel.GetMatchingGroup(Card.IsType,p,LOCATION_MZONE,0,nil,TYPE_LINK)+Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	Duel.ChangeTargetCard(ev,g)
end
