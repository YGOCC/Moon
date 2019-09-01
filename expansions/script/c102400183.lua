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
	return c:IsFaceup() and c:IsSetCard(0xd10) and c:IsAbleToHand()
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFlagEffect(tp,id)~=0 then return end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
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
