--Reneutrix Amy
function c240100232.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 "Reneutrix" monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd10),2,2)
	--Your linked monsters cannot be destroyed by card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--If a card(s) is returned to the Deck: Reverse the directions of the Link Arrows of all monsters currently on the field.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c240100232.mcon())
	e2:SetOperation(c240100232.lmop)
	c:RegisterEffect(e2)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o2:SetProperty(EFFECT_FLAG_DELAY)
	o2:SetCondition(c240100232.ocon())
	c:RegisterEffect(o2)
end
function c240100232.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100232.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100232.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100232.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100232.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_LEFT]	  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP]		 =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
