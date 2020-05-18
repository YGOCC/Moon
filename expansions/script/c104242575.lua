--Moon's Dream: Inside The Pot
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetLabel(0)
	e1:SetCost(function(e) e:SetLabel(1) return true end)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
--filters
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.cfilter(c,tp)
	return c:IsSetCard(0x666) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then if e:GetLabel()~=1 or not  Duel.IsPlayerCanDraw(tp,2) then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,3,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,3,3,nil,tp):GetFirst()
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.Draw(tp,2,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		Duel.Remove(frag,POS_FACEUP,REASON_EFFECT) 
		end
			if frag and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
			end
			Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local rm=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,2,2,nil)
					if rm:GetCount()>0 then
						Duel.Remove(rm,POS_FACEUP,REASON_EFFECT)
end
end
end