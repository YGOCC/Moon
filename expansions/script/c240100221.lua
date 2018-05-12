--Reneutrix Darcy
function c240100221.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 "Newtrix" monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd10),2,2)
	--Your linked monsters cannot be destroyed by card effects.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Once per turn (Quick Effect): You can Tribute 1 other card from your hand or field; reverse the directions of the Link Arrows of all monsters currently on the field.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c240100221.rmcost)
	e1:SetOperation(c240100221.lmop)
	c:RegisterEffect(e1)
end
function c240100221.filter(c)
	return c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanRelease(tp,c))
end
function c240100221.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100221.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c240100221.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(rg,REASON_COST)
end
function c240100221.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local t={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
	}
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100221.lmval(t))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100221.lmval(t)
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
