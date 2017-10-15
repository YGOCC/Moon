--Transfigure
function c982391022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c982391022.target)
	e1:SetOperation(c982391022.activate)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(957890213,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c982391022.thcost)
	e2:SetTarget(c982391022.thtg)
	e2:SetOperation(c982391022.thop)
	c:RegisterEffect(e2)
end
function c982391022.tgfilter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()==1 and c:IsRace(RACE_SPELLCASTER)
		and Duel.IsExistingMatchingCard(c982391022.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function c982391022.tgfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xfe9) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c982391022.spfilter(c,e,tp,att)
	return c:IsType(0x10000000) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0x4f000000,tp,true,false)
end
function c982391022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then
		return chkc:IsControler(tp) and ((chkc:IsLocation(LOCATION_MZONE) and c982391022.tgfilter(chkc,e,tp))
			or chkc:IsLocation(LOCATION_ONFIELD) and c982391022.tgfilter2(chkc))
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c982391022.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c982391022.tgfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c982391022.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local mt1=Duel.SelectMatchingCard(tp,c982391022.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local mt2=Duel.SelectMatchingCard(tp,c982391022.tgfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=mt1:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c982391022.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetAttribute())
		local sc=sg:GetFirst()
		if sc then
			local g=Group.CreateGroup()
			g:Merge(mt1)
			g:Merge(mt2)
			g:AddCard(e:GetHandler())
			sc:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+0x100000000)
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(sc,0x4f000000,tp,tp,true,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE)
				sc:RegisterEffect(e2)
				Duel.SpecialSummonComplete()
			end
			sc:CompleteProcedure()
		end
	end
end
function c982391022.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c982391022.thfil(c)
	return c:IsSetCard(0xfe9) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c982391022.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c982391022.thfil(chkc) and Duel.IsExistingTarget(c982391022.thfil,tp,LOCATION_DECK,0,1,nil) end
	if chk==0 then return Duel.IsExistingTarget(c982391022.thfil,tp,LOCATION_DECK,0,1,nil) end
	local sg=Duel.SelectTarget(tp,c982391022.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
end
function c982391022.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
