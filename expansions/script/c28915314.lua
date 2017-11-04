--Canesol
--Design and Code by Kindrindra--
local ref=_G['c'..28915314]
function ref.initial_effect(c)
	--Summon Other+Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28915314,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)--+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915314,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.lvtg)
	e2:SetOperation(ref.lvop)
	c:RegisterEffect(e2)
	--To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,28915314)
	e3:SetCondition(ref.grcon)
	e3:SetCost(ref.grcost)
	e3:SetTarget(ref.grtg)
	e3:SetOperation(ref.grop)
	c:RegisterEffect(e3)
end

function ref.ssfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x72C) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.ssfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		--Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function ref.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function ref.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,ref.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local t={}
	local i=2
	local p=1
	local lv=g:GetFirst():GetLevel()
	for i=2,4 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function ref.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

--To Grave
function ref.grcfilter(c)
	return c:IsSetCard(0x72D) and c:IsType(TYPE_MONSTER)
end
function ref.grcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.grcfilter,1,nil)
end
function ref.grcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function ref.grfilter(c)
	return c:IsSetCard(0x72C) and c:IsAbleToGrave()
end
function ref.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.grfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end


function ref.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function ref.thcfilter(c)
	return c:IsSetCard(0x72D) and c:IsType(TYPE_MONSTER)
end
function ref.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.thcfilter,1,nil)
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
