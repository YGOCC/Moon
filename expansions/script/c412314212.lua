--created by Jake, coded by Lyris, art by BachEric1461 of DeviantArt
local cid,id=GetID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DISCARD)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCondition(cid.con)
	e0:SetTarget(cid.sptg)
	e0:SetOperation(cid.spop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsRace(RACE_WARRIOR) end)
	e1:SetOperation(cid.matop)
	c:RegisterEffect(e1)
end
function cid.con(e,tp,eg,ep,ev,re,r,rp)
	local rs=r&0xc0
	local res=rs~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x613)
	if rs&REASON_COST==REASON_COST then res=res and re:IsHasType(0x7e0) end
	return res
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cid.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(aux.bdocon)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
