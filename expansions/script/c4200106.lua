--Godspark of Equality - Allia
--Created and Scripted by Swaggy
local m=4200106
local cm=_G["c"..m]
function cm.initial_effect(c)
--"The Mayakashi Clause"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.sslimit)
	c:RegisterEffect(e1)
	--spsummon self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4200106,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,4200106)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--Set a Spork from GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4200106,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.setcon)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
	end
function cm.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x412)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not (r==REASON_RULE)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.setfilter(c)
	return c:IsSetCard(0x412) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.sparkfilter(c)
return c:IsCode(4200100)
end
function cm.setcon(e,c)
    return Duel.IsExistingMatchingCard(cm.sparkfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
  local sg=Duel.SelectTarget(tp,cm.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local ifclause=false
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
Duel.SSet(tp,c)
Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
e1:SetValue(LOCATION_REMOVED)
c:RegisterEffect(e1)
	end
end
	