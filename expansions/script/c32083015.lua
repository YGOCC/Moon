--32083015
function c32083015.initial_effect(c)
--special summon
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(32083015,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetRange(LOCATION_MZONE)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_DESTROYED)
e1:SetTarget(c32083015.target)
e1:SetOperation(c32083015.operation)
c:RegisterEffect(e1)
		--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32083015,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c32083015.ntcon)
	e2:SetTarget(c32083015.tg)
	e2:SetOperation(c32083015.op)
	c:RegisterEffect(e2)
end
function c32083015.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7D53)
end
function c32083015.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c32083015.confilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c32083015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,10 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(32083015,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c32083015.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c32083015.filter(c,e,tp)
return c:IsSetCard(0x7D53)and c:IsLevelBelow(4)
and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32083015.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and Duel.IsExistingMatchingCard(c32083015.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32083015.operation(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,c32083015.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
if g:GetCount()>0 then
Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end