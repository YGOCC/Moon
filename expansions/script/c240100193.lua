--Reneutrix Mary
function c240100193.initial_effect(c)
	--If this card is Normal Summoned: Add 1 "Reneutrix" or Level 4 or lower LIGHT Fairy monster from your Deck to your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c240100193.mcon())
	e1:SetTarget(c240100193.target)
	e1:SetOperation(c240100193.operation)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	o1:SetCondition(c240100193.ocon())
	c:RegisterEffect(o1)
	--If your opponent activates a monster effect (Quick Effect): Rotate the Link Arrows of all monsters on the field 90 degrees clockwise.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c240100193.mcon(c240100193.condition))
	e2:SetOperation(c240100193.lmop)
	c:RegisterEffect(e2)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_QUICK_O)
	o2:SetCondition(c240100193.ocon(c240100193.condition))
	c:RegisterEffect(o2)
end
function c240100193.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100193.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100193.filter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) or c:IsSetCard(0xd10)) and c:IsAbleToHand()
end
function c240100193.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100193.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c240100193.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c240100193.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and ep~=tp
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c240100193.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100193.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100193.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP]		 =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_LEFT]	  =LINK_MARKER_BOTTOM,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
