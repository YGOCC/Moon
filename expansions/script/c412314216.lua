--created by Jake, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x613),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCondition(function(e,tp) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=3 end)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetCondition(cid.condition)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e3:SetTarget(cid.sptg)
	e3:SetOperation(cid.spop)
	c:RegisterEffect(e3)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_GRAVE)
end
function cid.thfilter(c,...)
	if ... and c:IsCode(...) then return false end
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	local t,g,tg={},Group.CreateGroup()
	local mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if mg:GetClassCount(Card.GetCode)<3 then return end
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tg=mg:FilterSelect(tp,cid.thfilter,1,1,nil,table.unpack(t))
		g=g+tg
		table.insert(t,tg:GetFirst():GetCode())
	end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
