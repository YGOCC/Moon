--Cards of Regality
local ref=_G['c'..28915120]
local id=28915120
function ref.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(ref.actcost)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
end

--Activate
function ref.cfilter(c)
	return c:IsType(TYPE_EXTRA) and not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function ref.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function ref.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	local val=1
	if Duel.GetFlagEffect(tp,1600000000)~=0 and Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(ref.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0))
		then val=2
	end
	e:SetLabel(val)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,val)
	if Duel.GetFlagEffect(tp,1600000000)~=0 then
		local g=Duel.GetMatchingGroup(ref.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	end
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local opt=e:GetLabel()
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,ref.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
	end
end
