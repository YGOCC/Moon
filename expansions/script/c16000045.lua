--ESPergear Knight : Gladiator 
function c16000045.initial_effect(c)
	aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,c16000045.checku,10,c16000045.matfilter,c16000045.filter2,c16000045.filter2)
	c:EnableReviveLimit() 
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000045,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,52068433)
	e1:SetCondition(c16000045.remcon)
	e1:SetTarget(c16000045.remtg)
	e1:SetOperation(c16000045.remop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16000045,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c16000045.descost)
	e3:SetTarget(c16000045.destg)
	e3:SetOperation(c16000045.desop)
	c:RegisterEffect(e3)
		  --Special SUmmon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16000045,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c16000045.spcon)
	e4:SetTarget(c16000045.sumtg)
	e4:SetOperation(c16000045.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)  
end
function c16000045.matfilter(c,ec,tp)
   return c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c16000045.checku(sg,ec,tp)
return sg:IsExists(Card.IsCode,1,nil,16000020)
end
function c16000045.filter2(c,ec,tp)
	return (c:IsType(TYPE_UNION) and c:IsRace(RACE_MACHINE)) or c:IsRace(RACE_PSYCHO)
end
function c16000045.xxfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c16000045.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end

function c16000045.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c16000045.xxfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c16000045.xxfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	 Duel.SetChainLimit(aux.FALSE)
end
function c16000045.remop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c16000045.xxfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	 Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c16000045.filter(c)
	return not c:IsDisabled()
end
function c16000045.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c16000045.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chkc then return chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c16000045.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c16000045.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c16000045.desop(e,tp,eg,ep,ev,re,r,rp)
	  local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c16000045.distg)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c16000045.discon)
		e2:SetOperation(c16000045.disop)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c16000045.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c16000045.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function c16000045.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c16000045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c16000045.mgfilter(c,e,tp,sync)
return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		or  not  r==REASON_MATERIAL+0x10000000
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c16000045.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return mg:GetCount()>0 and ft>=mg:GetCount() 
		and not mg:IsExists(c16000045.mgfilter,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,mg:GetCount(),tp,0)
end
function c16000045.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if mg:GetCount()>ft 
		or mg:IsExists(c16000045.mgfilter,1,nil,e,tp,e:GetHandler()) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
