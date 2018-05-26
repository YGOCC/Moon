--Break! Morph!
local ref=_G['c'..28916046]
local id=28916046
function ref.initial_effect(c)
	aux.AddEquipProcedure(c,nil,ref.actfilter)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(ref.sscon)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	--Float
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(ref.eqcon)
	e2:SetTarget(ref.eqtg)
	e2:SetOperation(ref.eqop)
	c:RegisterEffect(e2)
end
function ref.actfilter(c)
	return true
end

--Special Summon
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local bc=ec:GetBattleTarget()
	return e:GetHandler():GetEquipTarget()==eg:GetFirst() and bc:IsReason(REASON_BATTLE)
end
function ref.filter(c,e,tp)
	local lv=c:GetLevel()
	local att=c:GetAttribute()
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,att)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function ref.spfilter(c,e,tp,lv,att)
	return c:IsSetCard(0xc2) and not c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function ref.chkfilter(c,tc)
	local lv=tc:GetLevel()
	local att=tc:GetAttribute()
	return c:IsFaceup() and not c:IsAttribute(att)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and ref.chkfilter(chkc,e:GetLabelObject()) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabelObject(g:GetFirst())
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	local lv=tc:GetLevel()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,att)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end

--Float
function ref.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function ref.tgfilter(c,tp)
	return c:IsFaceup()	and Duel.IsExistingMatchingCard(ref.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c,tp)
end
function ref.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and (c:IsSetCard(1849) or c:IsCode(63851864)) and not c:IsCode(id)
		 and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function ref.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.tgfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(ref.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,ref.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function ref.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,ref.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
