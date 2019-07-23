--Cosmic Winged Egg by TKNight

function c901.initial_effect(c) 
	--equip from MMZ
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(16000031,0))
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(c901.eqtg)
	e0:SetOperation(c901.eqop)
	c:RegisterEffect(e0)
	--equip from Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000031,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c901.eqtg2)
	e1:SetOperation(c901.eqop2)
	c:RegisterEffect(e1)
		--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(901,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c901.sptg)
	e2:SetOperation(c901.spop)
	c:RegisterEffect(e2)
---destroy sub
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetValue(c901.repval)
	c:RegisterEffect(e5)
	--eqlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c901.eqlimit)
	c:RegisterEffect(e6)
	
	
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(901,0))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCountLimit(1,901)
	e7:SetCondition(c901.condition)
	e7:SetTarget(c901.target)
	e7:SetOperation(c901.operation)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	
			--atk,def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetValue(500)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e10)
end


function c901.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c901.eqlimit(e,c)
	return c:IsOnField() and not c:IsType(TYPE_TOKEN) or e:GetHandler():GetEquipTarget()==c
end
--equip from MMZ functions
function c901.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return  c:IsOnField() and not c:IsType(TYPE_TOKEN) and ct2==0
end

function c901.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c901.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(901)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c901.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c901.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(901,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c901.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c901.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
		Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c901.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)

	
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
--equip from Hand functions
function c901.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c901.filter(chkc) end
	if chk==0 then return  e:GetHandler():GetFlagEffect(901)==0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c901.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c901.filter,tp,LOCATION_MZONE,0,1,1,nil)
	c:RegisterFlagEffect(901,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c901.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end

	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c901.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c901.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--special summon
function c901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(901)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(901,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c901.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end


--search
function c901.cfilter(c)
	return c:GetSequence()>=5
end
function c901.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c901.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--cost
function c901.searchfilter(c)
	return  c:IsSetCard(0xB3F)and not c:IsCode(901) and c:IsAbleToHand()
end
function c901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c901.searchfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c901.operation(e,tp,eg,ep,ev,re,r,rp)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c901.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

