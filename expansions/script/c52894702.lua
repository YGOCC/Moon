--Onigami Hippokelpie
--Scripted by Kedy
--Concept by XStutzX
local function ID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
--[[Must be Fusion Summoned. You can only resolve each effect of "Onigami Hippokelpie" once per turn. 
If this card was Fusion Summoned this turn (Quick Effect): You can target up to 2 face-up cards; flip them face-down, then, shuffle 1 face-down card into the Deck. 
When a card is flipped face-down: You can return 1 Link Monster from the field to the Extra Deck.]]
local id,cod=ID()
function cod.initial_effect(c)
	--Fusion Summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf05a),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),true)
	--Sp Summon Con
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--Face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cod.fdcost)
	e1:SetCondition(cod.fdcon)
	e1:SetTarget(cod.fdtg)
	e1:SetOperation(cod.fdop)
	c:RegisterEffect(e1)
	--Return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(cod.rtcon)
	e2:SetTarget(cod.rttg)
	e2:SetOperation(cod.rtop)
	c:RegisterEffect(e2)
end

--Face-down
function cod.fdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id+100)==0 and Duel.GetFlagEffect(tp,id)==0 end
	e:GetHandler():RegisterFlagEffect(id+100,RESET_CHAIN,0,1)
end
function cod.fdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()==Duel.GetTurnCount() and e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function cod.pfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cod.fdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cod.pfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cod.pfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function cod.fdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetFlagEffect(tp,id)~=0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(tg) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		local sg=g:Select(tp,1,1,nil)
		if #sg<=0 then return end
		Duel.BreakEffect()
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

--Return
function cod.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end
function cod.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cod.cfilter,1,nil)
end
function cod.rfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function cod.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
end
function cod.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cod.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end