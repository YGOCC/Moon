--Reneutrix Mary
function c240100193.initial_effect(c)
	--If this card is Summoned: Add 1 Level 4 Cyberse monster from your Deck to your hand, except "Newtrix Maryl".
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(2)
	e2:SetCondition(c240100193.mcon())
	e2:SetTarget(c240100193.target)
	e2:SetOperation(c240100193.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	o2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	o2:SetCondition(c240100193.ocon())
	c:RegisterEffect(o2)
	local o3=o2:Clone()
	o3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(o3)
	local o4=o2:Clone()
	o4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(o4)
	--If you would Normal or Special Summon this card while you control a monster, you must use the Main Monster Zone of those monsters' columns or 1 of their adjacent columns.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_COST)
	e0:SetCost(c240100193.spchk)
	e0:SetOperation(c240100193.spcost)
	c:RegisterEffect(e0)
	local o0=e0:Clone()
	e0:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e0)
	--If this card and/or another monster(s) is Special Summoned while a Link Monster is on the field: Rotate the Link Arrows of all monsters currently on the field by 90 degrees clockwise.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c240100193.mcon(c240100193.modcon))
	e1:SetOperation(c240100193.lmop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DAMAGE_STEP)
	o1:SetCondition(c240100193.ocon(c240100193.modcon))
	c:RegisterEffect(o1)
end
function c240100193.spchk(e,te_or_c,tp)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	if g:GetCount()==0 then return true end
	for tc in aux.Next(g) do
		if tc:GetColumnZone(LOCATION_MZONE,1,1,tp)>0 then return true end
	end
	return false
end
function c240100193.spcost(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	if g:GetCount()==0 then return end
	local flag=0
	for tc in aux.Next(g) do
		flag=flag|tc:GetColumnZone(LOCATION_MZONE,1,1,e:GetHandlerPlayer())
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(flag)
	Duel.RegisterEffect(e1,tp)
end
function c240100193.modcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg,TYPE_LINK) and not e:GetHandler():IsStatus(STATUS_CHAINING) and (Duel.GetCurrentPhase()~=PHASE_DAMAGE (or not Duel.IsDamageCalculated() and (e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (eg:GetCount()==1 and eg:IsContains(e:GetHandler())))))
end
function c240100193.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100193.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
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
		[LINK_MARKER_TOP]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
function c240100193.filter(c)
	return c:GetLevel()==4 and c:IsRace(RACE_CYBERS) and c:IsAbleToHand() and not c:IsCode(240100193)
end
function c240100193.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_TRIGGER_F)
		or Duel.IsExistingMatchingCard(c240100193.filter,tp,LOCATION_DECK,0,1,nil) end
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
