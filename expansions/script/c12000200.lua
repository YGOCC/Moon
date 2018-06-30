--Dimension Dragons' Grand Core
function c12000200.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000200,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,12000200)
	e1:SetCondition(c12000200.spcon)
	e1:SetTarget(c12000200.sptg)
	e1:SetOperation(c12000200.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000200,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e2:SetCountLimit(1,112000300)
	e2:SetCondition(c12000200.sspcon)
	e2:SetTarget(c12000200.ssptg)
	e2:SetOperation(c12000200.sspop)
	c:RegisterEffect(e2)
	--cannot be used as Link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12000200,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e4:SetCountLimit(1,112000400)
	e4:SetCondition(aux.exccon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c12000200.thtg)
	e4:SetOperation(c12000200.thop)
	c:RegisterEffect(e4)
end
function c12000200.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsSetCard(0x855)
end
function c12000200.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12000200.cfilter,1,nil,tp)
end
function c12000200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12000200.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12000200.sspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c12000200.spfilter(c,e,tp)
	return c:IsCode(12000200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000200.ssptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c12000200.spfilter,tp,LOCATION_DECK,0,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12000200.sspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g2=Duel.SelectMatchingCard(tp,c12000200.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c12000200.thfilter(c)
	return c:IsCode(12000201) and c:IsAbleToHand()
end
function c12000200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000200.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12000200.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000200.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end