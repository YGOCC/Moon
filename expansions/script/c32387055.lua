--Payday!
function c32387055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,32387055)
	e1:SetTarget(c32387055.target)
	e1:SetOperation(c32387055.activate)
	c:RegisterEffect(e1)
end
function c32387055.gfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7E83)
end
function c32387055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c32387055.gfilter,tp,LOCATION_MZONE,0,nil)
		local ct=Duel.GetMatchingGroupCount(c32387055.gfilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(ct)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c32387055.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c32387055.gfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetMatchingGroupCount(c32387055.gfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(p,ct,REASON_EFFECT)
end
