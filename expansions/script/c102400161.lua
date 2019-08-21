--created & coded by Lyris
--火良運ピ
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DRAW)
	e1:SetCost(cid.spcost1)
	e1:SetTarget(cid.sptg1)
	e1:SetOperation(cid.spop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cid.hlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetTarget(cid.tg)
	e3:SetOperation(cid.op)
	c:RegisterEffect(e3)
end
function cid.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cid.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsReason(REASON_EFFECT) or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cid.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0
		or c:IsReason(REASON_EFFECT) then return end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cid.hlimit(e)
	local tp,ht=e:GetHandlerPlayer(),{Duel.IsPlayerAffectedByEffect(tp,EFFECT_HAND_LIMIT)}
	table.remove(ht,e)
	local ct=6
	for _,he in ipairs(ht) do
		local hc=he:GetValue()
		if type(hc)=='function' then hc=hc(e) end
		if hc~=ct then ct=hc end
	end
	return ct+1
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	if #g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_RULE)
		Duel.Draw(1-tp,1,REASON_RULE)
	end
end
