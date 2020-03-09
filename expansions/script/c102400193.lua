--created & coded by Lyris, art from "Destiny HERO - Dreamer"
--フェイツ・イリュージョンガイ
local cid,id=GetID()
function cid.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(cid.rlevel)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.tfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED)) and c:IsSetCard(0xf7a)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsExists(cid.tfilter,1,e:GetHandler()) or not g:IsExists(Card.IsAbleToHand,1,nil)
		or not Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_CARD,0,id)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cid.efilter)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cid.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function cid.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if e:GetHandler():IsLocation(LOCATION_SZONE) then lv=e:GetHandler():GetOriginalLevel() end
	if c:IsSetCard(0xf7a) and not c:IsCode(id) then
		local clv=c:GetLevel()
		if c:IsLocation(LOCATION_SZONE) then clv=c:GetOriginalLevel() end
		return lv*(0x1<<16)+clv
	else return lv end
end
