--Ashfallen Shaman
--salamangreat spinny, wattkinetic puppeteer, bls envoy, akz the pumer
--dark armed dragon, foolish burial, dual assembwurm, chick the yellow
--Wightmare, Shutendoji, Gozuki, trishula, gallant granite
--orcust automaton, orcustrated core, goddess of sweet revenge
--luna the dark spirit
function c17000800.initial_effect(c)
   --Send to GY
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(17000800,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,17000800)
	e1:SetCost(c17000800.seqcost)
   e1:SetTarget(c17000800.seqtg)
	e1:SetOperation(c17000800.seqop)
	c:RegisterEffect(e1)
   --SS from GY
   local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17000800,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17000800)
	e2:SetCondition(c17000800.sscon)
	e2:SetTarget(c17000800.sstg)
	e2:SetOperation(c17000800.ssop)
	c:RegisterEffect(e2)
end
--SS from GY
function c17000800.ssfilter(c)
   return c:IsFaceup() and c:IsSetCard(0x318) and c:IsType(TYPE_MONSTER)
end
function c17000800.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17000800.ssfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c17000800.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17000800.ssop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
--Quick Effect
function c17000800.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c17000800.seqfilter(c)
   return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemove() and not c:IsCode(17000800)
end
function c17000800.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c17000800.seqop(e,tp,eg,ep,ev,re,r,rp,chk)
   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
   --Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   if Duel.IsExistingMatchingCard(c17000800.seqfilter,tp,LOCATION_GRAVE,0,1,nil)
      and Duel.SelectYesNo(tp,aux.Stringid(17000800,2)) then
      Duel.BreakEffect()
      local tc=Duel.SelectMatchingCard(tp,c17000800.seqfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
      Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
   end
end
