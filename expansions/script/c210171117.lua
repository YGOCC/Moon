--Sacred Spirit of the Nekroz
function c210171117.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c210171117.matfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,210171117)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c210171117.cost)
	e2:SetTarget(c210171117.target)
	e2:SetOperation(c210171117.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,210171117)
	e3:SetCondition(c210171117.thcon)
	e3:SetTarget(c210171117.thtg)
	e3:SetOperation(c210171117.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e4)
end
function c210171117.matfilter(c)
	return c:IsLinkSetCard(0xb4) and not c:IsLinkCode(210171117)
end
function c210171117.filter(c,e,tp,m1,m2,ft)
	if not c:IsSetCard(0xb4) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c:IsCode(21105106) then return c:ritual_custom_condition(mg,ft) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if mg:IsContains(c) then mg:RemoveCard(c) end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c210171117.mfilterf,1,nil,tp,mg,c)
	end
end
function c210171117.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c210171117.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c210171117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c210171117.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c210171117.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return Duel.IsExistingMatchingCard(c210171117.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c210171117.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c210171117.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c210171117.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if mg:IsContains(tc) then mg:RemoveCard(tc) end
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c210171117.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c210171117.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c210171117.thfilter(c)
	return c:IsSetCard(0xb4) and c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function c210171117.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210171117.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210171117.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210171117.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end