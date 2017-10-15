--created by Outlaw, coded by Lyris
--サイバー・クイーン・ライリス
function c240100036.initial_effect(c)
c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c240100036.fscondition)
	e1:SetOperation(c240100036.fsoperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c240100036.sstg)
	e2:SetOperation(c240100036.ssop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c240100036.tdtg)
	e3:SetOperation(c240100036.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c240100036.rfgcon)
	e4:SetTarget(c240100036.rfgtg)
	e4:SetOperation(c240100036.rfgop)
	c:RegisterEffect(e4)
end
function c240100036.filter(c,e,tp,targ)
	if targ==1 then return c:IsSetCard(0x93) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() end
	if targ==2 then return c:IsSetCard(0x93) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end
	if targ==3 then return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove() end
	if targ==4 then return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x93) end
	if targ==5 then return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if targ==6 then return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeck() end
end
function c240100036.spfilter(c,mg)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x93)
end
function c240100036.fscondition(e,mg,gc)
	if mg==nil then return false end
	if gc then return false end
	return mg:IsExists(c240100036.spfilter,2,nil,mg)
end
function c240100036.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=eg:FilterSelect(tp,c240100036.spfilter,2,63,nil,eg)
	Duel.SetFusionMaterial(g)
end
function c240100036.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c240100036.filter,tp,LOCATION_DECK,0,1,nil,e,tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c240100036.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c240100036.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,5)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c240100036.ftarget)
		e1:SetLabel(g:GetFirst():GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c240100036.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c240100036.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c240100036.filter,tp,LOCATION_GRAVE,0,1,c,e,tp,6) end
	if Duel.SelectYesNo(tp,aux.Stringid(240100036,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c240100036.filter,tp,LOCATION_GRAVE,0,1,1,c,e,tp,6)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g:GetFirst(),1,0,0)
	return true
	else return false end   
end
function c240100036.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
end
function c240100036.rfgcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c240100036.rfgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingTarget(c240100036.filter,tp,LOCATION_GRAVE,0,1,c,e,tp,3)
		 and Duel.IsExistingTarget(c240100036.filter,tp,LOCATION_GRAVE,0,1,c,e,tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c240100036.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c240100036.rfgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local hg=Duel.SelectMatchingCard(tp,c240100036.filter,tp,LOCATION_GRAVE,0,1,1,c,e,tp,3)
		if hg:GetCount()>0 then
			hg:AddCard(c)
			Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
			local g1=Duel.SelectMatchingCard(tp,c240100036.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,2)
			g1:AddCard(tc)
			if g1:GetCount()>0 then
				Duel.SendtoHand(g1,nil,0,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			end
		end
	end
end
