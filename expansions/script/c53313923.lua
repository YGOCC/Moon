--Mysterious Supernova Dragon
function c53313923.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--You can target 1 monster you control: Destroy all monsters on the field with a different attribute than that monster, but for the rest of that turn, only that monster can attack.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c53313923.target)
	e1:SetOperation(c53313923.operation)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1,false)
	--Materials: 1 "Mysterious" Dragon monster + 1 LIGHT monster
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),c53313923.ffilter,true)
	--You can also summon this card by banishing the above monsters from your hand, Extra Deck or field (You do not use "Polymerization").
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c53313923.sprcon)
	e2:SetOperation(c53313923.sprop)
	e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	--Once per turn: You can banish 1 monster from your GY, add 1 banished card to your hand with a different name than the banished monster.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e3:SetTarget(c53313923.thtg)
	e3:SetOperation(c53313923.thop)
	c:RegisterEffect(e3)
	--If you have no face-up Pandemonium monster in your Spell/Trap zone: Destroy this card.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c53313923.sdcon)
	c:RegisterEffect(e4)
	--If this card would leave the field, You can set it to your Spell/Trap zone instead.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetTarget(c53313923.reptg)
	c:RegisterEffect(e5)
end
function c53313923.dfilter(c,at)
	return c:IsFaceup() and c:GetAttribute()~=at
end
function c53313923.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	local dg=Duel.GetMatchingGroup(c53313923.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,g:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c53313923.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local dg=Duel.GetMatchingGroup(c53313923.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetAttribute())
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c53313923.ffilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0xcf6)
end
function c53313923.sprfilter1(c,fc,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c53313923.sprfilter2,tp,0x46,0,1,Group.FromCards(c,fc),fc,c)
end
function c53313923.sprfilter2(c,fc,tc)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsRace(RACE_DRAGON) and c:IsSetCard(0xcf6) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc))>0
end
function c53313923.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsFacedown() and Duel.IsExistingMatchingCard(c53313923.sprfilter1,tp,0x46,0,1,c,c,tp)
end
function c53313923.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c53313923.sprfilter1,tp,0x46,0,1,1,c,c,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c53313923.sprfilter2,tp,0x46,0,1,1,Group.FromCards(c,tc),c,tc)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c53313923.filter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c53313923.filter3,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,c:GetCode())
end
function c53313923.filter3(c,code1,code2)
	return not c:IsCode(code1) and (not code2 or not c:IsCode(code2)) and c:IsAbleToHand()
end
function c53313923.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53313923.filter2,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c53313923.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if e:GetHandler():IsHasEffect(53313927) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c53313923.filter2,tp,LOCATION_GRAVE,0,1,ct,nil,tp)
	local t={}
	local code=0
	for tc in aux.Next(g) do
		code=tc:GetCode()
		t[code]=true
		--This card gains the effects of every card banished by its effect.
		e:GetHandler():CopyEffect(code,RESET_EVENT+0x1fe0000)
	end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		if g:GetCount()>1 then Duel.GetFieldCard(tp,LOCATION_SZONE,5):RegisterFlagEffect(53313927,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c53313923.filter3,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,table.unpack(t))
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c53313923.sdcon(e)
	return not Duel.IsExistingMatchingCard(aux.PaCheckFilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c53313923.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:GetDestination()~=LOCATION_OVERLAY and not c:IsReason(REASON_REPLACE)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SSET) end
	if Duel.SelectYesNo(tp,1159) then
		aux.PandSSet(c,REASON_EFFECT+REASON_REPLACE)(e,tp,eg,ep,ev,re,r,rp)
		return true
	else return false end
end
