--Cyber-Dragon-Summoner Caster
function c249000209.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16898077,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c249000209.destg)
	e2:SetOperation(c249000209.desop)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88264978,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c249000209.sptg)
	e4:SetOperation(c249000209.spop)
	c:RegisterEffect(e4)
end
function c249000209.desfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1A7) or c:IsRace(RACE_DRAGON))
end
function c249000209.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c249000209.descfilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(ct)
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local ct=e:GetLabel()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,ct,0,0)
end
function c249000209.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c249000209.descfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c249000209.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c249000209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000209.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c249000209.cfilter(c)
	return c:IsSetCard(0x1A7) and not c:IsCode(249000209) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVEYARD))
end
function c249000209.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000209.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--immune spell
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(c249000209.efilter)
			tc:RegisterEffect(e2)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_MACHINE+RACE_DRAGON)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			if (not Duel.IsExistingMatchingCard(c249000209.cfilter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_PZONE+LOCATION_GRAVE,0,1,nil)) then
				Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
			end
		end
	end
end
function c249000209.efilter(e,te)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end