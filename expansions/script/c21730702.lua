--Prank-Kids Pranks (Alt.)
--By Auramram
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.summon_tg)
	e2:SetOperation(s.summon_op)
	c:RegisterEffect(e2)
	--shuffle/draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+1000)
	e3:SetTarget(s.draw_tg)
	e3:SetOperation(s.draw_op)
	c:RegisterEffect(e3)
end
--summon
function s.token_check(tp)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x120,0x4011,1500,1500,4,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE)
end
function s.summon_tg_filter(c,e,tp)
	return c:IsSetCard(0x120) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsDiscardable() and s.token_check(tp))
end
function s.summon_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.summon_tg_filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.summon_op_filter(c,e,tp)
	return c:IsSetCard(0x120) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsDiscardable())
end
function s.summon_op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,s.summon_op_filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc then
			local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			local b2=tc:IsDiscardable() and s.token_check(tp)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			elseif Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)>0 
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and s.token_check(tp) then
				local token=Duel.CreateToken(tp,id+1)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end
function s.shuffle_filter(c)
	return c:IsSetCard(0x120) and c:IsAbleToDeck()
end
function s.draw_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.shuffle_filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(s.shuffle_filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.shuffle_filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.draw_op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
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
