--created & coded by Lyris, art from "Destiny HERO - Diamond Dude"
--フェイツ・デーンティー・ダイヤガル
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cid.chainop)
	c:RegisterEffect(e1)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_SPELL) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #tg>0 then
			Duel.HintSelection(tg)
			Duel.Destroy(tg,REASON_EFFECT)
		end
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
function cid.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c:IsAbleToDeck() and not c:IsCode(id)
end
function cid.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xf7a) then Duel.SetChainLimit(function(e,rp,tp) return tp==rp end) end
end
