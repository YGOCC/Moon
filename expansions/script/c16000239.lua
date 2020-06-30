--Paintress Nadia
local cid,id=GetID()
	local ref=_G['c'..id]
function cid.initial_effect(c)

 
	--hand 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.matcon)
	--e1:SetValue(cid.matval)
	e1:SetOperation(ref.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cid.ctcon)
	e2:SetOperation(cid.ctop)
	c:RegisterEffect(e2)
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,id)
	e3:SetCondition(cid.thcon)
	e3:SetTarget(cid.thtg)
	e3:SetOperation(cid.thop)
	c:RegisterEffect(e3)
end
function cid.matcon(c,ec,mode)
	if mode==1 then return Duel.GetFlagEffect(c:GetControler(),id)==0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function cid.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_EFFECT)
end
function cid.matval(e,c,mg)
	return c:IsSetCard(0xc50) and mg:IsExists(cid.mfilter,1,nil)
end
function ref.matop(c)
	Duel.SendtoGrave(c,REASON_MATERIAL+0x10000000)
end
function cid.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function cid.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_EVOLUTE and c:GetReasonCard():IsSetCard(0xc50)
end
function cid.spfilter(c,e,tp)
	return c:IsType(TYPE_EVOLUTE) and c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cid.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	tc:AddEC(4)
	end
end