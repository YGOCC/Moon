--Reneutrix Cadence
function c240100220.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 Cyberse monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERS),2,2)
	--Once per turn, if a "Newtrix" monster(s) is Normal or Special Summoned to a zone(s) this card points to: Return all monsters this card points to to the hand.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(1104)
	e2:SetCountLimit(1)
	e2:SetCondition(c240100220.mcon(c240100220.damcon))
	e2:SetTarget(c240100220.thtg)
	e2:SetOperation(c240100220.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local o2=e2:Clone()
	o2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	o2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY)
	o2:SetCondition(c240100220.ocon(c240100220.damcon))
	c:RegisterEffect(o2)
	local o3=o2:Clone()
	o3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(o3)
	--Once per turn (Quick Effect): You can Tribute 1 other card from your hand or field; flip the Link Arrows of all monsters currently on the field horizontally or vertically.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c240100220.rmcost)
	e1:SetOperation(c240100220.lmop)
	c:RegisterEffect(e1)
end
function c240100220.lfilter(c)
	return c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanRelease(tp,c))
end
function c240100220.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100220.lfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c240100220.lfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(rg,REASON_COST)
end
function c240100220.lmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local t={[0]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_BOTTOM_RIGHT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_BOTTOM,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_RIGHT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_LEFT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_TOP]   =LINK_MARKER_TOP,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_TOP_LEFT,
	},[1]={
		[LINK_MARKER_BOTTOM_LEFT]   =LINK_MARKER_TOP_LEFT,
		[LINK_MARKER_BOTTOM]		=LINK_MARKER_TOP,
		[LINK_MARKER_BOTTOM_RIGHT]  =LINK_MARKER_TOP_RIGHT,
		[LINK_MARKER_LEFT]  =LINK_MARKER_LEFT,
		[LINK_MARKER_RIGHT]   =LINK_MARKER_RIGHT,
		[LINK_MARKER_TOP_LEFT]  =LINK_MARKER_BOTTOM_LEFT,
		[LINK_MARKER_TOP]   =LINK_MARKER_BOTTOM,
		[LINK_MARKER_TOP_RIGHT]  =LINK_MARKER_BOTTOM_RIGHT,
	}}
	local op=Duel.SelectOption(tp,aux.Stringid(122518919,5),aux.Stringid(122518919,6))
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetLabel(tc:GetLinkMarker())
		e1:SetValue(c240100220.lmval(t[op]))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c240100220.lmval(t)
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
function c240100220.mcon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return not e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100220.ocon(excon)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(240100231)
					and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
			end
end
function c240100220.filter(c,g)
	return c:IsFaceup() and c:IsSetCard(0xd10) and g:IsContains(c)
end
function c240100220.damcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c240100220.filter,1,nil,lg)
end
function c240100220.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	if chk==0 then return lg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c240100220.thop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	Duel.SendtoHand(lg,nil,REASON_EFFECT)
end
