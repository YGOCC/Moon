--Newtrix Skydance
function c240100245.initial_effect(c)
	c:EnableReviveLimit()
	--Materials:2 "Newtrix" monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd10),2,2)
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
	--If you would Special Summon this card without using materials while you control a monster, you must use the Monster Zone of those monsters' columns or 1 of their adjacent columns.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c240100245.spchk)
	e0:SetOperation(c240100245.spcost)
	c:RegisterEffect(e0)
	--If this card and/or another monster(s) is Special Summoned while a Link Monster is on the field: Rotate the Link Arrows of all monsters currently on the field by 90 degrees clockwise.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c240100245.mcon(c240100245.modcon))
	e1:SetOperation(c240100245.lmop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	o1:SetCondition(c240100245.ocon(c240100245.modcon))
	c:RegisterEffect(o1)
end
function c240100245.spchk(e,te_or_c,tp)
	if e:GetHandler():GetMaterialCount()>0 then return true end
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	if g:GetCount()==0 then return true end
	for tc in aux.Next(g) do
		if tc:GetColumnZone(LOCATION_MZONE,1,1,tp)>0 then return true end
	end
	return false
end
function c240100245.spcost(e,tp,eg,ep,ev,re,r,rp)
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
function c240100245.modcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg,TYPE_LINK) and not e:GetHandler():IsStatus(STATUS_CHAINING) and (Duel.GetCurrentPhase()~=PHASE_DAMAGE (or not Duel.IsDamageCalculated() and (e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (eg:GetCount()==1 and eg:IsContains(e:GetHandler())))))
end
function c240100245.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100245.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100245.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100245.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100245.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_RIGHT]	  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP]		  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP_LEFT]	=LINK_MARKER_RIGHT,
		[LINK_MARKER_LEFT]		=LINK_MARKER_TOP_RIGHT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
