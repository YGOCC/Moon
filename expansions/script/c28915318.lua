--Liberator
--Design and Code by Kindrindra--
local ref=_G['c'..28915318]
function ref.initial_effect(c)
	c:EnableReviveLimit()
	--custom fusion procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(ref.fuscon)
	e1:SetOperation(ref.fusop)
	c:RegisterEffect(e1)
	--Shuffle+Bounce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915318,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.tdtg)
	e2:SetOperation(ref.tdop)
	c:RegisterEffect(e2)
	--Float
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,28915318)
	e3:SetCondition(ref.thcon)
	e3:SetTarget(ref.thtg)
	e3:SetOperation(ref.thop)
	c:RegisterEffect(e3)
end

--Fusion Condition
function ref.ffilter1(c)
	return (c:IsFusionSetCard(0x72C) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function ref.ffilter2(c,fc)
	return (c:IsFusionSetCard(0x72C) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function ref.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function ref.check1(c,mg,sg,chkf)
	local g=mg:Clone()
	if sg:IsContains(c) then g:Sub(sg) end
	return g:IsExists(ref.check2,1,c,c,chkf)
end
function ref.check2(c,c2,chkf)
	local g=Group.FromCards(c,c2)
	if g:IsExists(aux.TuneMagFusFilter,1,nil,g,chkf) then return false end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=g:GetFirst()
	while tc do
		if ref.ffilter1(tc) or tc:IsHasEffect(511002961) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if ref.ffilter2(tc) or tc:IsHasEffect(511002961) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2c,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2c,1,nil,g2) end
end
function ref.ffilter3(c)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToGrave()
end
function ref.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return ref.check1(gc,mg,sg,chkf)
	end
	return Duel.IsExistingMatchingCard(ref.ffilter3,tp,LOCATION_DECK,0,1,nil)
		and mg:IsExists(ref.check1,1,nil,mg,sg,chkf)
end
function ref.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.ffilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.BreakEffect()
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=mg:FilterSelect(p,ref.check2,1,1,gc,gc,chkf)
		local tc1=g1:GetFirst()
		if sfhchk then Duel.ShuffleHand(tp) end
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g1=mg:FilterSelect(p,ref.check1,1,1,nil,mg,exg,chkf)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(p,ref.check2,1,1,tc1,tc1,chkf)
	if ref.exfilter(g2:GetFirst(),eg) then fc:RemoveCounter(tp,0x16,3,REASON_EFFECT) end
	g1:Merge(g2)
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(g1)
end

--Shuffle+Bounce
function ref.tgfilter(c)
	return c:IsSetCard(0x72C) and c:IsAbleToDeck()
end
function ref.desfilter(c)
	return ref.tgfilter(c)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,0,0,LOCATION_ONFIELD,1,c)
end
function ref.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and ref.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.desfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,ref.desfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function ref.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

--Float
function ref.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY)
end
function ref.thfilter(c)
	return c:IsSetCard(0x72C) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.thfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,ref.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
