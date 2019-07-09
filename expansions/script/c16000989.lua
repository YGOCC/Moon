--Conjoint Sorceress
function c16000989.initial_effect(c)
	aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
   aux.AddEvoluteProc(c,nil,5,c16000989.filter1,c16000989.filter1)  
--Conjoint Procedure
	--equip
	local e999=Effect.CreateEffect(c)
	e999:SetDescription(aux.Stringid(16000989,0))
	e999:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e999:SetType(EFFECT_TYPE_IGNITION)
	e999:SetRange(LOCATION_MZONE)
	e999:SetTarget(c16000989.eqtg)
	e999:SetOperation(c16000989.eqop)
	c:RegisterEffect(e999)
  --unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000989,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_OVERLAY)
	e2:SetTarget(c16000989.sptg)
	e2:SetOperation(c16000989.spop)
	c:RegisterEffect(e2)
	  --destroy replace
	local e987=Effect.CreateEffect(c)
	e987:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e987:SetCode(EFFECT_DESTROY_REPLACE)
	e987:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e987:SetRange(LOCATION_MZONE)
	e987:SetTarget(16000989.reptg)
	c:RegisterEffect(e987)
end

function c16000989.filter1(c,ec,tp)
	return not c:IsType(TYPE_TOKEN)
end
function c16000989.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EVOLUTE) 
end
function c16000989.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16000989.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(16000989)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c16000989.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c16000989.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(16000989,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c16000989.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e)  then return end
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or not c16000989.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not  Duel.Overlay(tc,Group.FromCards(c)) and  tc:RefillEC( ) ==0 and tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)==0  then return end
	
function c16000989.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(16000989)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(16000989,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c16000989.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 tc:RemoveEC(tp,GetEC,REASON_EFFECT)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c16000989.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
   
end

function c16000989.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
	   -- c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end