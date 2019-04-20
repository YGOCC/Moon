--Clay Statue of the Orichalcos
function c32084010.initial_effect(c)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32084010,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c32084010.spcon)
	e4:SetTarget(c32084010.sptg)
	e4:SetOperation(c32084010.spop)
	c:RegisterEffect(e4)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32084010,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c32084010.spcondd)
	e1:SetTarget(c32084010.tg)
	e1:SetOperation(c32084010.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c32084010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c32084010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32084010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count = 0
	if e:GetLabel() then
		count =  e:GetLabel()
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e5:SetValue(500*(1+count))
		c:RegisterEffect(e5)
		e:SetLabel(count+1)
	end
end
function c32084010.spcondd(e,tp,eg,ep,ev,re,r,rp)
	return not re or re:GetOwner()~=c
end
function c32084010.filter(c,e,tp)
	return c:IsSetCard(0x7D54) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ROCK) and c:GetLevel()==4
end
function c32084010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32084010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c32084010.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32084010.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end