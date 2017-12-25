--Reneutrix Cadence
function c240100194.initial_effect(c)
	--If a card(s) is added to your opponent's hand, except during the Draw Phase: Target 1 "Reneutrix" monster in your GY; Special Summon this card from your hand, then return that target to your hand (if any).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+240100194)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetCondition(c240100194.mcon(c240100194.spcon))
	e1:SetTarget(c240100194.sptg)
	e1:SetOperation(c240100194.spop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	o1:SetCondition(c240100194.ocon(c240100194.spcon))
	c:RegisterEffect(o1)
	--If your opponent activates a Trap Card or effect (Quick Effect): Flip the Link Arrows of all monsters currently on the field vertically.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c240100194.mcon(c240100194.condition))
	e2:SetOperation(c240100194.lmop)
	c:RegisterEffect(e2)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_QUICK_O)
	o2:SetCondition(c240100194.ocon(c240100194.condition))
	c:RegisterEffect(o2)
	if not c240100194.global_check then
		c240100194.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c240100194.regcon)
		ge1:SetOperation(c240100194.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c240100194.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100194.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100194.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL
end
function c240100194.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd10) and c:IsAbleToHand()
end
function c240100194.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100194.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c240100194.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c240100194.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c240100194.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW then return false end
	local v=0
	if eg:IsExists(Card.IsControler,1,nil,0) then v=v+1 end
	if eg:IsExists(Card.IsControler,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c240100194.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+240100194,re,r,rp,ep,e:GetLabel())
end
function c240100194.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and ep~=tp
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c240100194.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100194.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100194.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]	=LINK_MARKER_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]		=LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_RIGHT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
