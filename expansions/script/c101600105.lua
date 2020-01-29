--Archfiend
function c101600105.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600105,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c101600105.spcon)
	e1:SetTarget(c101600105.sptg)
	e1:SetOperation(c101600105.spop)
	e1:SetCountLimit(1,11610105)
	c:RegisterEffect(e1)
	--"synchro custom"
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101600105,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101600105.target)
	e4:SetOperation(c101600105.operation)
	e4:SetCountLimit(1,101610105)
	c:RegisterEffect(e4)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101600105,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c101600105.damcon)
	e3:SetTarget(c101600105.damtg)
	e3:SetOperation(c101600105.damop)
	e3:SetCountLimit(1,101600105)
	c:RegisterEffect(e3)
end
function c101600105.cfilter(c)
	return c:IsSetCard(0xcd01) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c101600105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroup(tp,LOCATION_MZONE,0):IsExists(c101600105.cfilter,1,nil)
end
function c101600105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c101600105.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--redirect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		--level
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(4)
		e2:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e2)
	end
end
function c101600105.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c101600105.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c101600105.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c101600105.filter(c,e,tp)
	local lv=c:GetLevel()
	local lv2=e:GetHandler():GetOriginalLevel()
	return lv>0 and c:IsSetCard(0xcd01) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101600105.exfilter,tp,LOCATION_EXTRA,0,1,nil,lv+lv2,e,tp)
end
function c101600105.exfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsRace(RACE_DRAGON) and c:IsSetCard(0xcd01)
		and c:IsType(TYPE_SYNCHRO)
end
function c101600105.ex(c,tc)
	return c:GetSequence()==4 or c:GetSequence()==5 and c:GetLinkedGroup():IsContains(tc)
end
function c101600105.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local xtra=Duel.GetMatchingGroup(c101600105.ex,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	if chk==0 then return (Duel.GetLocationCountFromEx(tp)>0 or xtra:GetCount()>0)
		and e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101600105.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101600105.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local rg=Group.FromCards(g:GetFirst(),e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(e:GetHandler():GetLevel()+g:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101600105.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101600105.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
