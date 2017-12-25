--Reneutrix Becky
function c240100215.initial_effect(c)
	--If a card(s) is sent to your opponent's GY by battle or card effect: Target 1 LIGHT Fairy monster you control, except "Reneutrix Becky"; Special Summon this card from your hand to a column adjacent to that monster, then return it to the hand.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetCondition(c240100215.mcon(c240100215.spcon))
	e4:SetTarget(c240100215.sptg)
	e4:SetOperation(c240100215.spop)
	c:RegisterEffect(e4)
	local o4=e4:Clone()
	o4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	o4:SetCondition(c240100215.ocon(c240100215.spcon))
	c:RegisterEffect(o4)
	--If your opponent activates a Spell Card or effect (Quick Effect): Rotate the Link Arrows of all monsters currently on the field by 90 degrees counterclockwise.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c240100215.mcon(c240100215.condition))
	e2:SetOperation(c240100215.lmop)
	c:RegisterEffect(e2)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_QUICK_O)
	o2:SetCondition(c240100215.ocon(c240100215.condition))
	c:RegisterEffect(o2)
end
function c240100215.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100215.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100215.spfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c240100215.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c240100215.spfilter,1,nil,1-tp)
end
function c240100215.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and not c:IsCode(240100215)
end
function c240100215.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c240100215.cfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c240100215.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c240100215.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local zone=tc:GetColumnZone(LOCATION_MZONE,1,1,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and zone~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c240100215.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and ep~=tp
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c240100215.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		--Debug.ShowHint("Before: "..tc:GetLinkMarker())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100215.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		--Debug.ShowHint("After: "..tc:GetLinkMarker())
	end
end
function c240100215.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]	   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
