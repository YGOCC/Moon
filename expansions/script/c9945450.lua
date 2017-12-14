--Zodiac's Twilight Zone
function c9945450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Ritual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945450,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c9945450.target)
	e2:SetOperation(c9945450.activate)
	e2:SetCountLimit(1,9945450)
	c:RegisterEffect(e2)
	--NSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9945450,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9945451)
	e3:SetTarget(c9945450.ntg)
	e3:SetOperation(c9945450.nop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9945450,2))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c9945450.reptg)
	e4:SetValue(c9945450.repval)
	e4:SetCountLimit(1,9945452)
	e4:SetOperation(c9945450.repop)
	c:RegisterEffect(e4)
end
function c9945450.spfilter(c,e,tp)
	return c:IsSetCard(0x12D7) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,tp,false,true)
end
function c9945450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x12D7)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and g:GetClassCount(Card.GetCode)>=3 and Duel.IsExistingMatchingCard(c9945450.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
end
function c9945450.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-3 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x12D7)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		g1:Merge(g3)
		Duel.Release(g1,REASON_RITUAL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g4=Duel.SelectMatchingCard(tp,c9945450.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g4:GetFirst()
			if tc then
			tc:SetMaterial(g1)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c9945450.nfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x12D7)
end
function c9945450.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945450.nfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9945450.nop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9945450.nfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c9945450.repfilter(c,tp,e)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_SPIRIT) and c:GetDestination()==LOCATION_HAND or c:GetDestination()==LOCATION_DECK
end
function c9945450.desfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c9945450.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945450.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and eg:IsExists(c9945450.repfilter,1,nil,tp,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(9945450,1)) then
		local g=eg:Filter(c9945450.repfilter,nil,tp,e)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c9945450.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.HintSelection(tg)
		Duel.SetTargetCard(tg)
		tg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c9945450.repval(e,c)
	return c==e:GetLabelObject()
end
function c9945450.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	e:GetHandler():RegisterFlagEffect(9945450,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end