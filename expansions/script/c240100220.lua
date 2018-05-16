--Reneutrix Cadence
function c240100220.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 Cyberse monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),2,2)
	local k1=Effect.CreateEffect(c)
	k1:SetType(EFFECT_TYPE_SINGLE)
	k1:SetCode(EFFECT_MATERIAL_CHECK)
	k1:SetValue(c240100220.matcheck)
	c:RegisterEffect(k1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabelObject(k1)
	e1:SetCondition(c240100220.mcon(c240100220.drcon))
	e1:SetTarget(c240100220.drtg)
	e1:SetOperation(c240100220.drop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	o1:SetLabelObject(k1)
	o1:SetCondition(c240100220.ocon(c240100220.drcon))
	c:RegisterEffect(o1)
	--While there there are 2 or more Link Monsters on the field with Link Arrows pointing in the same direction, all your opponent's monsters lose ATK/DEF equal to half their original ATK/DEF.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c240100220.con)
	e2:SetValue(function(e,c) return -c:GetBaseAttack()/2 end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(function(e,c) return -c:GetBaseDefense()/2 end)
	c:RegisterEffect(e3)
	--Once per turn (Quick Effect): You can Tribute 1 other card from your hand or field; flip the Link Arrows of all monsters currently on the field horizontally or vertically.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCost(c240100220.rmcost)
	e0:SetOperation(c240100220.lmop)
	c:RegisterEffect(e0)
end
function c240100220.filter(c,tp)
	return c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE))
end
function c240100220.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100220.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c240100220.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.Release(rg,REASON_COST)
end
function c240100220.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local t={[0]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_TOP,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT,
	},[1]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_RIGHT,
	}}
	local op=Duel.SelectOption(tp,aux.Stringid(122518919,5),aux.Stringid(122518919,6))
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100220.lmval(t[op]))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100220.lmval(t)
	return  function(e,c)
				local curMark=e:GetLabel()
				local linkMod=t
				local chgMark=0
				for mark=0,8 do
					if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
				end
				return chgMark
			end
end
function c240100220.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100220.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100220.matcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0xd10)
	e:SetLabel(g:GetClassCount(Card.GetCode))
end
function c240100220.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c240100220.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (ct>0 and Duel.IsPlayerCanDraw(tp,ct)) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c240100220.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=e:GetLabelObject():GetLabel()
	if gc>0 then
		Duel.Draw(p,gc,REASON_EFFECT)
	end
end
function c240100220.cfilter1(c,tp)
	return c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c240100220.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLinkMarker())
end
function c240100220.cfilter2(c,blm)
	local curMark=c:GetLinkMarker()
	local t={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_RIGHT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|t[1<<mark] end
	end
	return chgMark&blm~=0
end
function c240100220.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c240100220.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
