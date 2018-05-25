--Mysterious Dimension
function c53313927.initial_effect(c)
	--When this card is activated: You can add 1 "Mysterious" monster from your Deck to your hand. (HOPT1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53313927)
	e1:SetOperation(c53313927.activate)
	c:RegisterEffect(e1)
	--Every time a monster is banished by the effect of a "Mysterious" monster, you can draw 1 card.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c53313927.drcon1)
	e2:SetOperation(c53313927.drop1)
	e2:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c53313927.regcon)
	e3:SetOperation(c53313927.regop)
	e3:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCondition(c53313927.drcon2)
	e4:SetOperation(c53313927.drop2)
	e4:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e4)
	--Once per turn, if the activated effect of a "Mysterious" monster you control would banish 1 monster, you can make that effect banish 1 other, appropriate monster in addition.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(53313927)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(function(e,c) return c:IsFaceup() and c:IsSetCard(0xcf6) and e:GetHandler():GetFlagEffect(53313927)==0 end)
	c:RegisterEffect(e7)
	--When you Special Summon a "Mysterious" monster from the Extra Deck (except during the Damage Step): You can draw 1 card. (HOPT2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,53313930)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetCondition(c53313927.drcon)
	e5:SetTarget(c53313927.drtg)
	e5:SetOperation(c53313927.drop)
	c:RegisterEffect(e5)
	--Once per turn: You can Banish 1 card from your Graveyard: add 1 other banished cards to your Hand. (HOPT3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1,53313931)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetTarget(c53313927.thtg)
	e6:SetOperation(c53313927.thop)
	c:RegisterEffect(e6)
end
function c53313927.afilter(c)
	return c:IsSetCard(0xcf6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c53313927.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c53313927.afilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,1109) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	elseif g:GetCount()>0 then e:SetCountLimit(e:GetCountLimit()+1) end
end
function c53313927.filter(c)
	local re=c:GetReasonEffect()
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0xcf6) and re:IsActiveType(TYPE_MONSTER)
end
function c53313927.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53313927.filter,1,nil)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c53313927.drop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp,1) or not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	Duel.Hint(HINT_CARD,0,53313927)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c53313927.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53313927.filter,1,nil)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c53313927.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,53313927,RESET_CHAIN,0,1)
end
function c53313927.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,53313927)>0
end
function c53313927.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,53313927)
	Duel.ResetFlagEffect(tp,53313927)
	if not Duel.IsPlayerCanDraw(tp,1) or not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	Duel.Hint(HINT_CARD,0,53313927)
	Duel.Draw(tp,n,REASON_EFFECT)
end
function c53313927.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsFaceup() and c:IsSetCard(0xcf6) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c53313927.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53313927.cfilter,1,nil,tp)
end
function c53313927.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c53313927.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c53313927.thcfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c53313927.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,c)
end
function c53313927.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcf6) and c:IsAbleToHand()
end
function c53313927.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53313927.thcfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c53313927.thcfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c53313927.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53313927.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
