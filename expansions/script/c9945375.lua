function c9945375.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x204F),aux.NonTuner(c9945375.syncfilter),1)
	c:EnableReviveLimit()
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9945375,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9945375)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9945375.negcon)
	e1:SetTarget(c9945375.negtg)
	e1:SetOperation(c9945375.negop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945375,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9945376)
	e2:SetCondition(c9945375.spcon)
	e2:SetTarget(c9945375.sptg)
	e2:SetOperation(c9945375.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9945375.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c9945375.syncfilter(c)
	return c:IsSetCard(0x204F) or c:IsType(TYPE_RITUAL)
end
function c9945375.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		 and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c9945375.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9945375.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) then
	if rc:GetAttack()>rc:GetDefense() then
	Duel.Recover(tp,rc:GetAttack()/2,REASON_EFFECT)
	elseif rc:GetAttack()<rc:GetDefense() then
	Duel.Recover(tp,rc:GetDefense()/2,REASON_EFFECT)
	end
end
end
function c9945375.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetLabel()==1
end
function c9945375.valfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c9945375.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c9945375.valfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c9945375.spfilter(c,lv,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToDeck() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x2050)
		and Duel.IsExistingMatchingCard(c9945375.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel(),e,tp)
end
function c9945375.spfilter2(c,lv,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x204f) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945375.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chck:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9945375.spfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c9945375.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9945375.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9945375.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=e:GetLabel()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9945375.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
			if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
