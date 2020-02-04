--created & coded by Lyris, art from "Destiny HERO - Doom Lord"
--フェイツ・ネクロガイ
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
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) or not re:GetHandler():IsLevelBelow(4) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(cid.retcon)
		e1:SetOperation(function(te) Duel.ReturnToField(te:GetLabelObject()) end)
		Duel.RegisterEffect(e1,tp)
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
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and (c:IsSSetable(true) or c:IsAbleToHand())
end
function cid.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function cid.thfilter(c)
	return c:IsSetCard(0xf7a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cid.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if e:GetHandler():IsLocation(LOCATION_SZONE) then lv=e:GetHandler():GetOriginalLevel() end
	if c:IsSetCard(0xf7a) and not c:IsCode(id) then
		local clv=c:GetLevel()
		return lv*(0x1<<16)+clv
	else return lv end
end
