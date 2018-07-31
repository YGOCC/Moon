--Teutonic Knight - Advanced Illumitenant
function c12000130.initial_effect(c)
	aux.AddLinkProcedure(c,c12000130.matfilter,1,1)
	c:EnableReviveLimit()
	--Add from GY to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TOGRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12000130)
	e1:SetCondition(c12000130.thcon)
	e1:SetTarget(c12000130.thtg)
	e1:SetOperation(c12000130.thop)
	c:RegisterEffect(e1)
	--GY Special
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,12000230)
	e2:SetCondition(c12000130.incon)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c12000130.spcost)
	e2:SetTarget(c12000130.sptg)
	e2:SetOperation(c12000130.spop)
    c:RegisterEffect(e2)
	end
--Link Mat Lock
function c12000130.matfilter(c)
	return c:IsLinkSetCard(0x857) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
--Add from GY to Hand
function c12000130.cfilter(c,tp)
	return c:IsPreviousSetCard(0x857) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
		and not c:IsLocation(LOCATION_DECK)
end
function c12000130.thfilter(c,tp)
	return c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x857) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c12000130.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12000130.cfilter,1,nil,tp)
end
function c12000130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12000130.thfilter,1,nil,tp) end
	local clone=eg:Clone()
	e:SetLabelObject(clone)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,clone,1,0,0)
end
function c12000130.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,c12000130.thfilter,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Special Summon from GY
function c12000130.incon(e)
	return e:GetHandler():GetLinkedGroupCount()==0
end
function c12000130.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12000130.spfilter1(c,e,tp)
	return c:IsSetCard(0x857) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c12000130.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c12000130.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c12000130.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end