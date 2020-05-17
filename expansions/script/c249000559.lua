--Transcended Mage Knight
function c249000559.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.TRUE,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1CD),2,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12298909,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,2490005591)
	e1:SetCondition(c249000559.discon)
	e1:SetCost(c249000559.discost)
	e1:SetTarget(c249000559.distg)
	e1:SetOperation(c249000559.disop)
	c:RegisterEffect(e1)	
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c249000559.splimit)
	c:RegisterEffect(e2)
	--change chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetTarget(c249000559.target)
	e3:SetOperation(c249000559.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11224103,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,2490005593)
	e4:SetCondition(c249000559.spcon)
	e4:SetTarget(c249000559.sptg)
	e4:SetOperation(c249000559.spop)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(31833038,0))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e5:SetCountLimit(1,2490005594)
	e5:SetCondition(aux.dscon)
	e5:SetTarget(c249000559.atktg)
	e5:SetOperation(c249000559.atkop)
	c:RegisterEffect(e5)
end
function c249000559.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainNegatable(ev)
end
function c249000559.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c249000559.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c249000559.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c249000559.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c249000559.tgfilter(c,e,tp,eg,ep,ev,re,r,rp)	
	if (not c:IsType(TYPE_EFFECT))	or (not c:IsType(TYPE_SYNCHRO+TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)) then return false end
	if not c:IsSummonableCard() and not c:IsType(TYPE_SYNCHRO+TYPE_XYZ) then return false end
	if (c:IsLocation(LOCATION_GRAVE) and (not c:IsAbleToRemove())) then return false end
	if (not c:IsLocation(LOCATION_GRAVE) and (not c:IsAbleToGrave())) then return false end
	if not global_card_effect_table[c] then return false end
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for key,value in pairs(global_card_effect_table[c]) do
		local etemp=value
		if etemp and (etemp:IsHasType(EFFECT_TYPE_IGNITION) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_O) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_F) or etemp:IsHasType(EFFECT_TYPE_QUICK_O)) then
			local tg=etemp:GetTarget()
			if etemp:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg(e,tp,eg,ep,ev,re,r,rp,0,e:GetLabelObject()) then
				t[p]=etemp
				desc_t[p]=etemp:GetDescription()
				p=p+1
			end
		end
	end
	return p >=2
end
function c249000559.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc
	if g then tc=g:GetFirst() end
	if tc then e:SetLabelObject(tc) end
	if chk==0 then return ep==tp and re:IsActiveType(TYPE_MONSTER) and g and g:GetCount()==1
		and Duel.IsExistingMatchingCard(c249000559.tgfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,re:GetHandler(),e,tp,eg,ep,ev,re,r,rp) end
end
function c249000559.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c249000559.tgfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,re:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_GRAVE) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) else Duel.SendtoGrave(tc,REASON_EFFECT) end
	local t={}
	local desc_t = {}
	local i=1
	local p=1
	for key,value in pairs(global_card_effect_table[tc]) do
		local etemp=value
		if etemp and (etemp:IsHasType(EFFECT_TYPE_IGNITION) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_O) or etemp:IsHasType(EFFECT_TYPE_TRIGGER_F) or etemp:IsHasType(EFFECT_TYPE_QUICK_O)) then
			local tg=etemp:GetTarget()
			if etemp:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg(e,tp,eg,ep,ev,re,r,rp,0,e:GetLabelObject()) then
				t[p]=etemp
				desc_t[p]=etemp:GetDescription()
				p=p+1
			end
		end
	end
	local index=1
	if p < 2 then return end
	if p > 2 then 
		index=Duel.SelectOption(tp,table.unpack(desc_t)) + 1
	end
	local te=t[index]
	Duel.ChangeChainOperation(ev,te:GetOperation())
end
function c249000559.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c249000559.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c249000559.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000559.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(c249000559.chlimit)
end
function c249000559.chlimit(e,ep,tp)
	return tp==ep
end
function c249000559.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end