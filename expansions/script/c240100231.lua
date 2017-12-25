--Reneutrix Carly
function c240100231.initial_effect(c)
	--If a monster is Link Summoned: Special Summon this card in face-up Defense Position to your zone it points to.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(2)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c240100231.mcon(c240100231.drcon))
	e1:SetTarget(c240100231.drtg)
	e1:SetOperation(c240100231.drop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_DELAY)
	o1:SetCondition(c240100231.ocon(c240100231.drcon))
	c:RegisterEffect(o1)
	--If a player(s) takes damage: You can flip the Link Arrows of all monsters currently on the field horizontally.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c240100231.mcon())
	e2:SetOperation(c240100231.lmop)
	c:RegisterEffect(e2)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o2:SetProperty(EFFECT_FLAG_DELAY)
	o2:SetCondition(c240100231.ocon())
	c:RegisterEffect(o2)
end
function c240100231.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100231.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100231.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	e:SetLabelObject(tg)
	return eg:GetCount()==1 and tg:IsSummonType(SUMMON_TYPE_LINK) and tg:GetLinkedZone(tp)>0
end
function c240100231.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c240100231.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetFirstTarget()
	if not tg or not tg:IsRelateToEffect(e) then return end
	local zone=tg:GetLinkedZone(tp)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end
function c240100231.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100231.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100231.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_LEFT]	=LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP]		=LINK_MARKER_TOP,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
