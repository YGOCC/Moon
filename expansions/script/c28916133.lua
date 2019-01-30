--LIGHT Fusion
--Design and Code by Kinny
local ref=_G['c'..28916133]
local id=28916133
function ref.initial_effect(c)
	--Material
	c:EnableReviveLimit()
	--aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe1),aux.FilterBoolFunction(Card.IsAttackBelow,3000),2,true)
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,1854),ref.ffilter,2,true)
	--On-Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.sscon1)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	--On-Material
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(ref.sscon2)
	c:RegisterEffect(e2)
	--Non-discard
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISCARD_COST_CHANGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(ref.costchange)
	c:RegisterEffect(e3)
end
function ref.ffilter(c,fc,sumtype,tp)
	return c:GetControler()==fc:GetControler()
end

--Remove
function ref.sscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function ref.sscon2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function ref.tgfilter(c,e,tp,fc)
	local att=c:GetAttribute()
	return ((fc:GetMaterial():IsContains(c) and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fc)
		or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)))
		and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp,att)
end
function ref.ssfilter(c,e,tp,att)
	return c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and Duel.IsExistingTarget(ref.tgfilter,tp,loc,loc,1,nil,e,tp,c) end
	if chkc then return ref.tgfilter(chkc,e,tp,c) end
	local g=Duel.SelectTarget(tp,ref.tgfilter,tp,loc,loc,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,ref.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetAttribute())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--NoCost
function ref.costchange(e,re,rp,val)
	if re and re:GetHander():IsSetCard(1854) then
		return 0
	else
		return val
	end
end
