--Iceborn Frostguard
function c11000379.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11000379)
	e1:SetTarget(c11000379.target)
	e1:SetOperation(c11000379.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11000379.thcon)
	e2:SetCost(c11000379.thcost)
	e2:SetTarget(c11000379.thtg)
	e2:SetOperation(c11000379.thop)
	c:RegisterEffect(e2)
end
function c11000379.filter(c,e,tp,m)
	if not c:IsSetCard(0x203) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c:IsCode(21105106) then return c:ritual_custom_condition(mg) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c11000379.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local af=Duel.IsPlayerAffectedByEffect(tp,11000385)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
        if af then return Duel.IsExistingMatchingCard(c11000379.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg) end
		return Duel.IsExistingMatchingCard(c11000379.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
    if af then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
        end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11000379.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Group.CreateGroup()
	if Duel.IsPlayerAffectedByEffect(tp,11000385) then
		tg=Duel.SelectMatchingCard(tp,c11000379.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,mg)
	else
		tg=Duel.SelectMatchingCard(tp,c11000379.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_DECK) then
			--disable fromdeck
			Duel.RegisterFlagEffect(tp,11000386,RESET_PHASE+PHASE_END,0,0)
		end
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		end
	end
end
function c11000379.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11000379.cfilter(c)
	return c:IsSetCard(0x203) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c11000379.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c11000379.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11000379.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11000379.thfilter(c)
	return c:IsSetCard(0x203) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c11000379.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000379.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11000379.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11000379.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
