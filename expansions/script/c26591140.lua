--Risveglio della Xenofiamma
--Script by XGlitchy30
function c26591140.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591140)
	e1:SetTarget(c26591140.target)
	e1:SetOperation(c26591140.activate)
	c:RegisterEffect(e1)
	--effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26591140,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c26591140.ecost)
	e2:SetTarget(c26591140.etg)
	e2:SetOperation(c26591140.eop)
	c:RegisterEffect(e2)
end
--filters
function c26591140.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0x23b9) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c:IsCode(26591136) then return c:ritual_custom_condition(mg,ft) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c26591140.mfilterf,1,nil,tp,mg,c)
	end
end
function c26591140.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c26591140.efilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x23b9) and ((c:IsAbleToDeck() and Duel.IsPlayerCanDraw(c:GetControler(),1)) or c:IsAbleToHand())
end
--Activate
function c26591140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c26591140.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c26591140.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26591140.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsCode(26591136) then
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
				mat=mg:FilterSelect(tp,c26591140.mfilterf,1,1,nil,tp,mg,tc)
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
--effects
function c26591140.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c26591140.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26591140.efilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26591140.efilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26591140.efilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	--options
	local opt=0
	if tc:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) and tc:IsAbleToHand() then
		opt=Duel.SelectOption(tp,aux.Stringid(26591140,1),aux.Stringid(26591140,2))
	elseif tc:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591140,1))
	elseif tc:IsAbleToHand() then
		opt=Duel.SelectOption(tp,aux.Stringid(26591140,2))+1
	else return end
	e:SetLabel(opt)
	--
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	end
end
function c26591140.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if e:GetLabel()==0 then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
			if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			if tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end