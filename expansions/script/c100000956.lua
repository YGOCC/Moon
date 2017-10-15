 --Created and coded by Rising Phoenix
function c100000956.initial_effect(c)
c:SetUniqueOnField(1,0,100000956)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x114),aux.NonTuner(Card.IsSetCard,0x114),1)
	c:EnableReviveLimit()
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000956,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1c0)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c100000956.targethh)
	e1:SetOperation(c100000956.activatehh)
	e1:SetCost(c100000956.cost)
	c:RegisterEffect(e1)		
		local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetCondition(c100000956.conua)
		e11:SetValue(c100000956.efilterua)
	c:RegisterEffect(e11)
	--half damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c100000956.dxcon)
	e4:SetOperation(c100000956.dxop)
	c:RegisterEffect(e4)
end
function c100000956.efilterua(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c100000956.dxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c100000956.dxop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c100000956.filterua(c)
	return c:IsFaceup() and c:IsCode(100000955)
end
function c100000956.conua(e)
	return Duel.IsExistingMatchingCard(c100000956.filterua,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c100000956.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x114)
end
function c100000956.rfilter(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000950)
end
function c100000956.rfilter2(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000949)
end
function c100000956.rfilter3(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000948)
end
function c100000956.rfilter4(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000951)
end
function c100000956.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000956.rfilter,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c100000956.rfilter2,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c100000956.rfilter3,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c100000956.rfilter4,tp,LOCATION_GRAVE,0,1,nil,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000956.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100000956.rfilter2,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c100000956.rfilter3,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c100000956.rfilter4,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	g:Merge(g1)
	g:Merge(g2)
	g:Merge(g3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100000956.targethh(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c100000956.activatehh(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end