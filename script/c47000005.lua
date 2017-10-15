--Digimon Geogreymon
function c47000005.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43751755,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c47000005.spcost)
	e1:SetTarget(c47000005.sptg)
	e1:SetOperation(c47000005.spop)
	c:RegisterEffect(e1)
	--To Hand
  	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43751755,1))
  	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  	e2:SetCode(EVENT_SUMMON_SUCCESS)
  	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  	e2:SetTarget(c47000005.thtg)
  	e2:SetOperation(c47000005.thop)
  	c:RegisterEffect(e2)
  	local e3=e2:Clone()
  	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  	c:RegisterEffect(e3)
	--name change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(47000003)
	c:RegisterEffect(e4)
end
function c47000005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c47000005.spfilter(c,e,tp)
	return c:IsCode(47000003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47000005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c47000005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c47000005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	g=Duel.SelectMatchingCard(tp,c47000005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c47000005.thfilter(c)
  return c:IsCode(47000008) and c:IsAbleToHand()
end
function c47000005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c47000005.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c47000005.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tg=Duel.GetFirstMatchingCard(c47000005.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end

