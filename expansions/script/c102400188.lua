--created & coded by Lyris, art from "Queen's Knight"
--フェイツ・ジョーカーガル
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(cid.tfilter,nil)
	if not tg or #tg==0 or not Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then return end
	Duel.BreakEffect()
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function cid.tfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED)) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
function cid.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
