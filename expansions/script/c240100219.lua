--Reneutrix Darcy
function c240100219.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 "Reneutrix" monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd10),2,2)
	--If a monster(s) leaves the field from a zone(s) this card points to: Target 1 Link Monster on the field; Special Summon 1 "Reneutrix" monster from your hand to a zone that target points to.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c240100219.mcon(c240100219.spcon))
	e1:SetTarget(c240100219.target)
	e1:SetOperation(c240100219.operation)
	c:RegisterEffect(e1)
	local o1=e1:Clone()
	o1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	o1:SetCondition(c240100219.ocon(c240100219.spcon))
	c:RegisterEffect(o1)
	--Ifa card(s) is Set: Rotate the Link Arrows of all monsters currently on the field by 45 degrees counterclockwise.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c240100219.mcon())
	e2:SetOperation(c240100219.lmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o2:SetProperty(EFFECT_FLAG_DELAY)
	o2:SetCondition(c240100219.ocon())
	c:RegisterEffect(o2)
	local o3=e3:Clone()
	o3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o3:SetProperty(EFFECT_FLAG_DELAY)
	o3:SetCondition(c240100219.ocon())
	c:RegisterEffect(o3)
end
function c240100219.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100219.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100233) and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100219.lfilter(c,zone)
	local seq=1<<c:GetPreviousSequence()
	return seq&zone==seq
end
function c240100219.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SUMMON) or Duel.CheckEvent(EVENT_FLIP_SUMMON) or Duel.CheckEvent(EVENT_SPSUMMON) then return false end
	return eg:IsExists(c240100219.lfilter,1,nil,e:GetHandler():GetLinkedZone())
end
function c240100219.cfilter(c,e,tp)
	local zone=c:GetLinkedZone(tp)
	return zone~=0 and Duel.IsExistingMatchingCard(c240100219.filter,tp,LOCATION_HAND,0,1,nil,zone,e,tp) and c:IsType(TYPE_LINK)
end
function c240100219.filter(c,zone,e,tp)
	return c:IsSetCard(0xd10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c240100219.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c240100219.cfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c240100219.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c240100219.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local zone=tc:GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c240100219.filter,tp,LOCATION_HAND,0,1,1,nil,zone,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c240100219.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100219.lmval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100219.lmval(e,c)
	local curMark=e:GetLabel()
	local linkMod={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP,
		[LINK_MARKER_TOP]	  =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
	}
	local chgMark=0
	for mark=0,8 do
		if 1<<mark&curMark==1<<mark then chgMark=chgMark|linkMod[1<<mark] end
	end
	return chgMark
end
