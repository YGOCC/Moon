--Rank-Up-Magic Creation Hyper-Drive
function c88880017.initial_effect(c)
	--(1)Xyz Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c88880017.target)
	e1:SetOperation(c88880017.activate)
	c:RegisterEffect(e1)
	--(2)Return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880017,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c88880017.rettg)
	e2:SetOperation(c88880017.retop)
	e2:SetCountLimit(1,88880017)
	c:RegisterEffect(e2)
	--(3)Return 2 add 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88880017,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c88880017.eftarg)
	e3:SetOperation(c88880017.efop)
	e3:SetCountLimit(1,88880017+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e3)
end
--(1)Xyz Summon
function c88880017.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x1889)
		and Duel.IsExistingMatchingCard(c88880017.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,c:GetRace(),c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c88880017.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and (c:IsSetCard(0x1889) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
end
function c88880017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c88880017.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c88880017.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c88880017.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88880017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88880017.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetRace(),tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
--(2)Return to hand
function c88880017.filter3(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsSetCard(0x889)
end
function c88880017.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c88880017.filter3,0,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c88880017.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
--(3)Return 2 add 1
function c88880017.filter4(c)
	return c:IsCode(88880017) and c:IsAbleToHand()
end
function c88880017.eftarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880017.filter4,tp,LOCATION_GRAVE,0,1,e:GetHandler()) 
	and Duel.IsExistingMatchingCard(c88880017.filter4,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(1,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880017.efop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c88880017.filter4,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g1:AddCard(e:GetHandler())
	if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
	  Duel.ConfirmCards(1-tp,g1)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g2=Duel.SelectMatchingCard(tp,c88880017.filter4,tp,LOCATION_DECK,0,1,1,nil)
	  if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	  end
	end
  end
end