--Reneutrix Amy
function c240100232.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2+ Cyberse monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERS),2,4)
	--If a card(s) is destroyed by a card effect: Inflict 400 damage to your opponent for each card destroyed.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCondition(c240100232.mcon(c240100232.damcon))
	e2:SetTarget(c240100232.target)
	e2:SetOperation(c240100232.operation)
	c:RegisterEffect(e2)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o2:SetCondition(c240100232.ocon(c240100232.damcon))
	c:RegisterEffect(o2)
	--If another "Newtrix" card or effect is activated (Quick Effect): Destroy as many random cards in the hand as possible, up to the number of monsters this card points to. You can only use this effect of "Newtrix Amy" once per turn.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,240100232)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCondition(c240100232.mcon(c240100232.descon))
	e3:SetTarget(c240100232.destg)
	e3:SetOperation(c240100232.desop)
	c:RegisterEffect(e3)
	local o3=e3:Clone()
	o3:SetType(EFFECT_TYPE_QUICK_O)
	o3:SetProperty(0)
	o3:SetCondition(c240100232.ocon(c240100232.descon))
	c:RegisterEffect(o3)
	--If you would Special Summon this card without using materials while you control a monster, you must use the Monster Zone of those monsters' columns or 1 of their adjacent columns.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c240100232.spchk)
	e0:SetOperation(c240100232.spcost)
	c:RegisterEffect(e0)
	--If this card and/or another monster(s) is Special Summoned while a Link Monster is on the field: Rotate the Link Arrows of all monsters currently on the field by 90 degrees clockwise.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c240100232.mcon(c240100232.modcon))
	e1:SetOperation(c240100232.lmop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	o1:SetCondition(c240100232.ocon(c240100232.modcon))
	c:RegisterEffect(o1)
end
function c240100232.spchk(e,te_or_c,tp)
	if e:GetHandler():GetMaterialCount()>0 then return true end
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	if g:GetCount()==0 then return true end
	for tc in aux.Next(g) do
		if tc:GetColumnZone(LOCATION_MZONE,1,1,tp)>0 then return true end
	end
	return false
end
function c240100232.spcost(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetMaterialCount()>0 then return end
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
function c240100232.modcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg,TYPE_LINK) and not e:GetHandler():IsStatus(STATUS_CHAINING) and (Duel.GetCurrentPhase()~=PHASE_DAMAGE (or not Duel.IsDamageCalculated() and (e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (eg:GetCount()==1 and eg:IsContains(e:GetHandler())))))
end
function c240100232.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100232.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
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
		[LINK_MARKER_LEFT]	=LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP]		=LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
function c240100232.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsReason,1,nil,REASON_EFFECT)
end
function c240100232.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(Card.IsReason,nil,REASON_EFFECT)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,ct*400)
end
function c240100232.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c240100232.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xd10)
end
function c240100232.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_QUICK_F) or Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,e:GetHandler():GetLinkedGroupCount(),PLAYER_NONE,LOCATION_HAND)
end
function c240100232.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	local sg=g:RandomSelect(tp,e:GetHandler():GetLinkedGroupCount())
	Duel.Destroy(sg,REASON_EFFECT)
end
