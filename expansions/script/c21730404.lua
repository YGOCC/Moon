--S.G. Firelauncher
function c21730404.initial_effect(c)
	--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730404,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21730404.spcon)
	c:RegisterEffect(e1)
	--destroy card on field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730404,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c21730404.descost)
	e2:SetTarget(c21730404.destg)
	e2:SetOperation(c21730404.desop)
	c:RegisterEffect(e2)
end
--special summon from hand
function c21730404.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--destroy card on field
function c21730404.desfilter(c,tp)
	return c:IsSetCard(0x719) and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c21730404.rcost(c)
	return c:IsCode(21730411) and c:IsReleasable() and not c:IsDisabled() and not c:IsForbidden()
end
function c21730404.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.CheckReleaseGroup(tp,c21730404.desfilter,1,false,nil,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c21730404.rcost,tp,LOCATION_FZONE,0,1,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost() and (b1 or b2) end
	if Duel.Remove(c,POS_FACEUP,REASON_COST)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TURN_END)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetOperation(c21730404.tgop)
		c:RegisterEffect(e1)
	end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(21730411,1))) then
		local tg=Duel.GetFirstMatchingCard(c21730404.rcost,tp,LOCATION_FZONE,0,nil)
		Duel.Release(tg,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,c21730404.desfilter,1,1,false,nil,nil,tp)
		Duel.Release(g,REASON_COST)
	end
end
function c21730404.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21730404.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--return to grave
function c21730404.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_RETURN)
end