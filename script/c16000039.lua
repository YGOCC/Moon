--ESPErgear Knight:Valkyrie
function c16000039.initial_effect(c)
--remove
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000039,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c16000039.negcon)
	e2:SetCost(c16000039.negcost)
	e2:SetTarget(c16000039.negtg)
	e2:SetOperation(c16000039.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16000039,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,52068433)
	e3:SetCondition(c16000039.remcon)
	e3:SetTarget(c16000039.remtg)
	e3:SetOperation(c16000039.remop)
	c:RegisterEffect(e3)
			--Special SUmmon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16000039,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c16000039.spcon)
	e4:SetTarget(c16000039.sumtg)
	e4:SetOperation(c16000039.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
		if not c16000039.global_check then
		c16000039.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c16000039.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c16000039.evolute=true
c16000039.material1=function(mc) return mc:IsCode(16000020) and mc:IsFaceup() end
c16000039.material2=function(mc) return mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsRace(RACE_MACHINE) and mc:IsType(TYPE_UNION) and mc:GetLevel()==5 and mc:IsFaceup() end
function c16000039.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
		c16000039.stage_o=9
c16000039.stage=c16000039.stage_o
end
function c16000039.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end

function c16000039.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,3,REASON_COST)
end
function c16000039.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16000039.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK) then
		if rc:IsAbleToHand()
			and Duel.SelectYesNo(tp,aux.Stringid(16000039,2)) then
			Duel.BreakEffect()
			Duel.SendtoHand(rc,tp,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,rc)
	end
end
end
function c16000039.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c16000039.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c16000039.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c16000039.filter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c16000039.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end
function c16000039.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c16000039.filter,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(c16000039.filter,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end
function c16000039.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c16000039.mgfilter(c,e,tp,sync)
return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		or  not  r==REASON_MATERIAL+0x10000000
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c16000039.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return mg:GetCount()>0 and ft>=mg:GetCount() 
		and not mg:IsExists(c16000039.mgfilter,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,mg:GetCount(),tp,0)
end
function c16000039.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if mg:GetCount()>ft 
		or mg:IsExists(c16000039.mgfilter,1,nil,e,tp,e:GetHandler()) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
