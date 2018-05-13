--Newtrix Skydance
function c240100224.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 "Newtrix" monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd10),2,2)
	local k1=Effect.CreateEffect(c)
	k1:SetType(EFFECT_TYPE_SINGLE)
	k1:SetCode(EFFECT_MATERIAL_CHECK)
	k1:SetValue(c240100224.matcheck)
	c:RegisterEffect(k1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabelObject(k1)
	e1:SetCondition(c240100224.drcon)
	e1:SetTarget(c240100224.drtg)
	e1:SetOperation(c240100224.drop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	o1:SetLabelObject(k1)
	o1:SetCondition(c240100224.ocon(c240100224.drcon))
	c:RegisterEffect(o1)
	--Your linked monsters cannot be targeted by card effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Once per turn (Quick Effect): You can Tribute 1 other card from your hand or field; rotate the Link Arrows of all monsters currently on the field by up to 4 spaces clockwise or counterclockwise.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCost(c240100224.rmcost)
	e0:SetOperation(c240100224.lmop)
	c:RegisterEffect(e0)
end
function c240100224.filter(c,tp)
	return c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE))
end
function c240100224.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100224.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c240100224.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.Release(rg,REASON_COST)
end
function c240100224.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local t={[0]={[1]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP,
		[LINK_MARKER_LEFT]  =LINK_MARKER_TOP_LEFT,
	},[2]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_TOP,
	},[3]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_TOP_RIGHT,
	}},[1]={[1]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP,
		[LINK_MARKER_TOP]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
	},[2]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM,
	},[3]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
	}},[2]={[4]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_RIGHT,
	}}}
	local a=Duel.AnnounceNumber(tp,1,2,3,4)
	local op=nil
	if a<4 then op=Duel.SelectOption(tp,aux.Stringid(122518919,5),aux.Stringid(122518919,6)) else op=2 end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100224.lmval(t[op][a]))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100224.lmval(t)
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
function c240100224.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100224.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100224.matcheck(e,c)
	e:SetLabel(c:GetMaterial():GetClassCount(Card.GetCode))
end
function c240100224.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c240100224.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (ct>0 and Duel.IsPlayerCanDraw(tp,ct)) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c240100224.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=e:GetLabelObject():GetLabel()
	if gc>0 then
		Duel.Draw(p,gc,REASON_EFFECT)
	end
end
