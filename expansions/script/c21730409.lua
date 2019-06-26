--A.O. Connector
function c21730409.initial_effect(c)
  --link procedure
  aux.AddLinkProcedure(c,nil,2,2,c21730409.lcheck)
	c:EnableReviveLimit()
  --unaffected
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730409,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c21730409.imval)
	c:RegisterEffect(e2)
  --draw
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetOperation(c21730409.regop)
  c:RegisterEffect(e3)
end
--link procedure
function c21730409.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x719)
end
--unaffected
function c21730409.imval(e,re)
	if not (re:GetOwnerPlayer()~=e:GetHandlerPlayer()) or not re:IsActivated() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
--draw
function c21730409.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730409,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,21730409)
  e1:SetReset(RESET_EVENT+0x86c0000+RESET_PHASE+PHASE_END)
	e1:SetTarget(c21730409.drtg)
	e1:SetOperation(c21730409.drop)
	c:RegisterEffect(e1)
end
function c21730409.drfilter(c)
	return c:IsSetCard(0x719) and c:IsAbleToDeck()
end
function c21730409.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21730409.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c21730409.drfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c21730409.drfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21730409.drop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
