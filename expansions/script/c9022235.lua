--Pandemoniumgraph Lich
local card = c9022235
function card.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(aux.PandActCheck)
	e1:SetTarget(card.prottg)
	e1:SetOperation(card.protop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1)
		--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9022235,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(card.sumtg)
	e2:SetOperation(card.sumop)
	c:RegisterEffect(e2)
end
function card.spfilter(c,e,tp)
	return c:IsSetCard(0xcf80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and not c:IsCode(9022235)
end
function card.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(card.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function card.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,card.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end
function card.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcf80) and c:IsType(TYPE_MONSTER)
end
function card.prottg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and card.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(card.indfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(9022235)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,card.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(9022235,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function card.protop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(card.valcon)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	tc:RegisterEffect(e1)
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
end
function card.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
