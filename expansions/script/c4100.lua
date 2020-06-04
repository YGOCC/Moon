--Dusk
function c4100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4100.target)
	e1:SetOperation(c4100.activate)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4100,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4100)
	e2:SetCondition(c4100.acon)
	e2:SetCost(c4100.acost)
	e2:SetTarget(c4100.atg)
	e2:SetOperation(c4100.aop)
	c:RegisterEffect(e2)
end
c4100.list={[0x01]=(0x08),[0x08]=(0x01),[0x02]=(0x04),
				[0x04]=(0x02),[0x10]=(0x20),[0x20]=(0x10)}
				
function c4100.filter1(c,e,tp)
	local code=c:GetAttribute()
	local tcode=c4100.list[code]
	return tcode and c:IsSetCard(0x1004101D) and Duel.IsExistingMatchingCard(c4100.filter2,tp,LOCATION_HAND,0,1,nil,tcode,e,tp)
end
function c4100.filter2(c,tcode,e,tp)
	return c:IsAttribute(tcode) and c:IsSetCard(0x10041036)and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c4100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c4100.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c4100.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetAttribute())
	Duel.SendtoGrave(rg,REASON_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4100.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local tcode=c4100.list[code]
	local tg=Duel.SelectMatchingCard(tp,c4100.filter2,tp,LOCATION_HAND,0,1,1,nil,tcode,e,tp)
	local tc=tg:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c4100.acon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c4100.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c4100.afilter(c)
	return c:IsCode(4101) and c:IsAbleToHand()
end
function c4100.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4100.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4100.aop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4100.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end