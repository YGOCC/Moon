--绝尘的影魔
local m=14060015
local cm=_G["c"..m]
cm.fit_monster={14060014}
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(cm.rettg)
	e2:SetOperation(cm.retop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC_G)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(cm.tgcon)
	c:RegisterEffect(e4)
end
function cm.filter(c,e,tp,m1,ft)
	if not c:IsSetCard(0x1406) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if mg:IsContains(c) then mg:RemoveCard(c) end
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
	end
end
function cm.filter1(c,e,tp,m1,ft)
	if not c:IsSetCard(0x1406) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local tc1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,2,nil)
			if tc1 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				--local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				--if ft>-1 then return true end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if tc then
					Duel.ConfirmCards(1-tp,tc)
					g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,2,2,nil,e,tp)
					Duel.SendtoGrave(g,nil,REASON_EFFECT)
					tc:SetMaterial(g)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			else
				local mg1=Duel.GetRitualMaterial(tp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				--if ft>-1 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg1,ft) then return true end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg1,ft)
				local tc=g:GetFirst()
				if tc then
					Duel.ConfirmCards(1-tp,tc)
					local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if mg:IsContains(tc) then mg:RemoveCard(tc) end
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
		end
	end
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
		c:ReverseInDeck()
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function cm.thfilter(c,e,tp)
	return c:IsCode(14060014) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end