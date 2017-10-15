--Digimon Infermon
function c47000028.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47000028,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c47000028.hspcon)
	e1:SetOperation(c47000028.hspop)
	c:RegisterEffect(e1)
	--Destroy + Search
  	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47000028,1))
  	e2:SetCategory(CATEGORY_DESTROY)
  	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  	e2:SetCode(EVENT_SUMMON_SUCCESS)
  	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  	e2:SetTarget(c47000028.destg)
  	e2:SetOperation(c47000028.desop)
  	c:RegisterEffect(e2)
  	local e3=e2:Clone()
  	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000028,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c47000028.thtg)
	e4:SetOperation(c47000028.thop)
	c:RegisterEffect(e4)
	--noxyz
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--synchrolimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c47000028.spfilter(c)
	return c:IsFaceup() and c:IsCode(47000027) and c:IsAbleToRemoveAsCost()
end
function c47000028.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c47000028.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c47000028.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c47000028.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47000028.desfilter(c)
  return c:IsDestructable()
end
function c47000028.sofilter(c)
  return c:IsSetCard(0x3E4) and c:IsCode(47000029) and c:IsAbleToHand()
end
function c47000028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and c47000028.desfilter(chkc) and chkc~=e:GetHandler() end
  if chk==0 then return Duel.IsExistingTarget(c47000028.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c47000028.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47000028.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c47000028.sofilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(47000028,0)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c47000028.sofilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
  end
end
function c47000028.thfilter(c)
	return c:IsCode(47000030) and c:IsAbleToHand()
end
function c47000028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c47000028.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47000028.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_GRAVE,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleDeck(tp)
	end
end

