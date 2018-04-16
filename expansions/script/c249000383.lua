--Elven Mage Paladin - Ruby
function c249000383.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,2490003831)
	e1:SetCondition(c249000383.spcon)
	e1:SetOperation(c249000383.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(249000338,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c249000383.destg)
	e2:SetOperation(c249000383.desop)
	c:RegisterEffect(e2)
	--summon synchro/xyz
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2490003832)
	e3:SetCost(c249000383.cost)
	e3:SetTarget(c249000383.target)
	e3:SetOperation(c249000383.operation)
	c:RegisterEffect(e3)
end
function c249000383.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,nil,0x1B7)
end
function c249000383.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,1,1,nil,0x1B7)
	Duel.Release(g,REASON_COST)
end
function c249000383.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000383.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c249000383.rmfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000383.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000383.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c249000383.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c249000383.tfilter(c,rc,e,tp,lvrk)
	return c:IsRace(rc) and 
	((c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:GetLevel() > lvrk and c:GetLevel() <= lvrk+3)
	or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetRank() > lvrk and c:GetRank() <= lvrk+3))
end
function c249000383.filter(c,e,tp)
	local lvrk
	if c:GetLevel() > c:GetRank() then lvrk = c:GetLevel() else lvrk = c:GetRank() end
	return lvrk > 0 and c:IsFaceup() and c:IsType(TYPE_SYNCHRO+TYPE_XYZ) and Duel.IsExistingMatchingCard(c249000383.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalRace(),e,tp,lvrk)
	and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000383.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler() 
	if chk==0 then return Duel.IsExistingTarget(c249000383.filter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000383.filter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
end
function c249000383.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local rc=tc:GetOriginalRace()
	local lvrk
	if tc:GetLevel() > tc:GetRank() then lvrk = tc:GetLevel() else lvrk = tc:GetRank() end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c249000384.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,rc,e,tp,lvrk):GetFirst()
	if not sc then return end
	if sc:IsType(TYPE_XYZ) then
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
		Duel.Overlay(sc,tc2)
		end
		tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(sc,tc2)
		end
		sc:CompleteProcedure()
	else
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()	
	end
end