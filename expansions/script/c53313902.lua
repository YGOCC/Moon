--Mysterious Blazar Dragon
function c53313902.initial_effect(c)
	--You can Special Summon this card (from your hand or GY) by Tributing 1 LIGHT monster you control and 1 "Mysterious" monster or card in your Pandemonium Zone. You can only Summon "Mysterious Blazar Dragon(s)" once per turn this way.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCountLimit(1,53313902)
	e0:SetCondition(c53313902.spcon)
	e0:SetOperation(c53313902.spop)
	c:RegisterEffect(e0)
	--If this card is Summoned: You can target 1 other Level/Rank 8 or lower face-up monster on the field; until the end of this turn, this card gains that target's effects (if any).
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetTarget(c53313902.target)
	e1:SetOperation(c53313902.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Once per turn, this card can't be destroyed by battle.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c53313902.valcon)
	c:RegisterEffect(e2)
end
function c53313902.rfilter(c,tp)
	return (c:IsSetCard(0xcf6) or c:IsLocation(LOCATION_SZONE)) and Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,c,ATTRIBUTE_LIGHT)
end
function c53313902.pzfilter(c)
	return aux.PaCheckFilter(c) and c:IsReleasable()
end
function c53313902.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c53313902.rfilter,nil,tp)+Duel.GetMatchingGroup(c53313902.pzfilter,tp,LOCATION_SZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and g:GetCount()>0
end
function c53313902.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.GetReleaseGroup(tp):Filter(c53313902.rfilter,nil,tp)+Duel.GetMatchingGroup(c53313902.pzfilter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,g1:GetFirst(),ATTRIBUTE_LIGHT)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c53313902.copytg(c)
	return c:IsFaceup() and (c:IsLevelBelow(8) or c:IsRankBelow(8))
end
function c53313902.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsLocation(LOCATION_MZONE) and c53313902.copytg(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c53313902.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetOperation(c53313902.rstop)
		c:RegisterEffect(e2)
	end
end
function c53313902.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53313902.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
