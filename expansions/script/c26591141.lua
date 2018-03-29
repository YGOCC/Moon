--Scudo Rovente della Xenofiamma
--Script by XGlitchy30
function c26591141.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591141)
	e1:SetTarget(c26591141.target)
	e1:SetOperation(c26591141.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c26591141.reptg)
	e2:SetValue(c26591141.repval)
	e2:SetOperation(c26591141.repop)
	c:RegisterEffect(e2)
end
--filters
function c26591141.tdfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x23b9) and c:IsAbleToDeck()
end
function c26591141.filter(c,e,tp,m1,m2)
	if not c:IsSetCard(0x23b9) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or c:IsCode(26591138) then return false end
	local mg=m1:Filter(c26591141.tdfilter,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	--else
		--return ft>-1 and mg:IsExists(c26591141.mfilterf,1,nil,tp,mg,c)
end
function c26591141.mfilterf(c,tp,mg,rc)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c26591141.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x23b9) and c:IsAbleToGrave()
end
function c26591141.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x23b9) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
--Activate
function c26591141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c26591141.tdfilter,tp,LOCATION_GRAVE,0,nil)
		local mg2=Duel.GetMatchingGroup(c26591141.mfilter,tp,LOCATION_DECK,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c26591141.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26591141.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c26591141.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local mg2=Duel.GetMatchingGroup(c26591141.mfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26591141.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
	local tc=g:GetFirst()
	if tc then
		mg1:Merge(mg2)
		if tc.mat_filter then
			mg1=mg1:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg1:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		--else
		--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		--	mat=mg:FilterSelect(tp,c26591141.mfilterf,1,1,nil,tp,mg,tc)
		--	Duel.SetSelectedCard(mat)
		--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		--	local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
		--	mat:Merge(mat2)
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsSetCard,nil,0x23b9)
		mat:Sub(mat2)
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--destroy replace
function c26591141.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c26591141.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c26591141.repval(e,c)
	return c26591141.repfilter(c,e:GetHandlerPlayer())
end
function c26591141.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end