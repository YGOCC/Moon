--created & coded by Lyris, art by minea-bun of DeviantArt
--ニュートリックス・マリー
function c240100175.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c240100175.mcon(c240100175.modcon))
	e1:SetOperation(c240100175.lmop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DAMAGE_STEP)
	o1:SetCondition(c240100175.ocon(c240100175.modcon))
	c:RegisterEffect(o1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c240100175.spcon)
	e2:SetValue(c240100175.spval)
	c:RegisterEffect(e2)
end
function c240100175.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and not c:IsCode(240100175) end,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return false end
	local zone,seq=0,0
	for tc in aux.Next(g) do
		seq=tc:GetSequence()
		if seq>0 and seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|(1<<seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|(1<<seq+1) end
		if seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1) then zone=zone|0x2 end
		if seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then zone=zone|0x8 end
	end
	zone=zone&0x7f
	e:SetLabel(zone)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c240100175.spval(e,c)
	return 0,e:GetLabel()
end
function c240100175.modcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg,TYPE_LINK) and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or (not Duel.IsDamageCalculated() and (e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (eg:GetCount()==1 and eg:IsContains(e:GetHandler())))))
end
function c240100175.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100175.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100175.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local t={[0]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_TOP,
	},[1]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM,
	}}
	local op=Duel.SelectOption(tp,aux.Stringid(122518919,5),aux.Stringid(122518919,6))
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100175.lmval(t[op]))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100175.lmval(t)
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
function c240100175.filter(c)
	return c:GetLevel()==4 and c:IsRace(RACE_CYBERS) and c:IsAbleToHand() and not c:IsCode(240100175)
end
function c240100175.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_TRIGGER_F)
		or Duel.IsExistingMatchingCard(c240100175.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100175.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c240100175.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
