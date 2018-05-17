--created & coded by Lyris, art by JetBlackStare77 of DeviantArt
--ニュートリックス・ベキー
function c240100176.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c240100176.mcon(c240100176.modcon))
	e1:SetOperation(c240100176.lmop)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	o1:SetCondition(c240100176.ocon(c240100176.modcon))
	c:RegisterEffect(o1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c240100176.spcon)
	e2:SetValue(c240100176.spval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,240100176)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetDescription(1108)
	e3:SetCondition(c240100176.mcon(c240100176.drcon))
	e3:SetTarget(c240100176.drtg)
	e3:SetOperation(c240100176.drop)
	c:RegisterEffect(e3)
	local o3=e3:Clone()
	o3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	o3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	o3:SetCondition(c240100176.ocon(c240100176.drcon))
	c:RegisterEffect(o3)
end
function c240100176.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and not c:IsCode(240100176) end,tp,LOCATION_MZONE,0,nil)
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
function c240100176.spval(e,c)
	return 1,e:GetLabel()
end
function c240100176.modcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg,TYPE_LINK) and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or (not Duel.IsDamageCalculated() and (e:IsHasType(EFFECT_TYPE_TRIGGER_F) or (eg:GetCount()==1 and eg:IsContains(e:GetHandler())))))
end
function c240100176.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100231) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100176.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100231) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100176.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local t={[0]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP,
		[LINK_MARKER_LEFT]  =LINK_MARKER_TOP_LEFT,
	},[1]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP,
		[LINK_MARKER_TOP]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
	}}
	local op=Duel.SelectOption(tp,aux.Stringid(122518919,5),aux.Stringid(122518919,6))
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100176.lmval(t[op]))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100176.lmval(t)
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
function c240100176.drcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c240100176.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_TRIGGER_F) or Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c240100176.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
