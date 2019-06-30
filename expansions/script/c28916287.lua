local id=28916287
local ref=_G['c'..id]
function ref.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,ref.lcheck)
	c:EnableReviveLimit()
	--Revive
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(ref.sscon)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	--Bounce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end
function ref.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x747)
end

function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterial():IsExists(ref.mfilter,1,nil)
end
function ref.mfilter(c)
	return c:IsType(TYPE_EXTRA) and not c:IsType(TYPE_LINK)
end
function ref.ssfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.ssfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end

--Bounce
function ref.thfilter(c,tp,lg)
	return c:IsFaceup() and lg:IsContains(c)
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and ref.thfilter(chkc,tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(ref.thfilter,tp,LOCATION_MZONE,0,1,nil,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,ref.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		--Control
		local token = Duel.CreateToken(0,0,0,0,0,0,tc:GetPreviousRaceOnField(),tc:GetPreviousAttributeOnField())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		--e1:SetLabel(tc:GetPreviousAttributeOnField())
		e1:SetLabelObject(tc)
		e1:SetCondition(ref.ctrcon)
		e1:SetOperation(ref.ctrop)
		Duel.RegisterEffect(e1,tp)
	end
end
function ref.ctrfilter(c,att,rac)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and (c:IsAttribute(att) or c:IsRace(rac))
end
function ref.ctrcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(ref.ctrfilter,tp,0,LOCATION_MZONE,1,nil,e:GetLabel(),e:GetLabelObject())
end
function ref.ctrop(e,tp,eg,ep,ev,re,r,rp)
	local token=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,ref.ctrfilter,tp,0,LOCATION_MZONE,1,1,nil,token:GetAttribute(),token:GetRace())
	if tc then
		Duel.GetControl(tc,tp)
	end
	Duel.Destroy(token)
end
