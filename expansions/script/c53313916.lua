--Mysterious Samsara Dragon
function c53313916.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--P: You can tribute 1 monster you control, then target 1 monster your opponent controls: Banish both it and this card, also shuffle this card banished this way into your deck at the end of the turn.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_SZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetCost(c53313916.rmcost)
	e0:SetTarget(c53313916.rmtg)
	e0:SetOperation(c53313916.rmop)
	c:RegisterEffect(e0)
	aux.EnablePandemoniumAttribute(c,e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e) return e:GetHandler():GetFlagEffect(53313916)>0 end)
	e1:SetOperation(function(e) Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) end)
	c:RegisterEffect(e1)
	--Cannot be Normal Summoned/Set.
	c:EnableReviveLimit()
	--Must be Special Summoned (from your hand) by tributing 4 Pandemonium cards you control, including at least 1 Dragon monster, 2 other monsters, and 1 card in your Spell/Trap zone.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c53313916.spcon)
	e3:SetOperation(c53313916.spop)
	c:RegisterEffect(e3)
	--M: Once per turn: You can look at your opponent's Extra Deck (if possible), also until the end of this turn, this card gains the effects of 1 other monster on either player's field, GY, or Extra deck, and it gains ATK and DEF equal to that monster's ATK.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c53313916.copytg)
	e4:SetOperation(c53313916.copy)
	c:RegisterEffect(e4)
	--M: This card is unaffected by your opponent's card effects.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c53313916.efilter)
	c:RegisterEffect(e5)
	--M: Once per turn: This card cannot be destroyed by battle.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e6:SetCountLimit(1)
	e6:SetValue(c53313916.valcon)
	c:RegisterEffect(e6)
end
function c53313916.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsControler,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,Card.IsControler,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c53313916.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c53313916.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_EFFECT)
	if c:IsLocation(LOCATION_REMOVED) then
		c:RegisterFlagEffect(53313916,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
function c53313916.spcfilter(c,tp)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsReleasable()
end
function c53313916.spcfilter1(c,g)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_DRAGON) and g:IsExists(Card.IsLocation,2,c,LOCATION_MZONE)
end
function c53313916.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c53313916.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
	return g:IsExists(c53313916.spcfilter1,1,nil,g) and g:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)
end
function c53313916.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c53313916.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c53313916.spcfilter1,1,1,nil,g)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:FilterSelect(tp,Card.IsLocation,2,2,tc,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g3=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_SZONE)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Release(g1,REASON_COST)
end
function c53313916.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0x54,0x54,1,e:GetHandler()) end
end
function c53313916.copy(e,tp,eg,ep,ev,re,r,rp)
	--You can look at your opponent's Extra Deck (if possible)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	--Until the end of this turn, this card gains the effects of 1 other monster on either player's field, GY, or Extra deck
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x54,0x54,1,1,c)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_EXTRA) then Duel.ConfirmCards(1-tp,tc)
		else Duel.HintSelection(sg) end
		c:CopyEffect(tc:GetCode(),RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		--This card gains ATK and DEF equal to that monster's ATK.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c53313916.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function c53313916.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
