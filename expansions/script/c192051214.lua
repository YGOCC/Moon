--coded by Lyris
--Steelus Incarnatem Ultima
function c192051214.initial_effect(c)
	c:EnableReviveLimit()
	--3 or more "Steelus" monsters.
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsSetCard,0x617),3,63,true)
	--When this card is Fusion Summoned: You can banish any number of "Steelus" monsters used as Fusion Material for this card from your Graveyard; inflict damage to your opponent equal to the number of monsters banished x 500, then draw 1 card for every 1000 damage inflicted to your opponent this way.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e1:SetCondition(c192051214.tgcon)
	e1:SetCost(c192051214.cost)
	e1:SetTarget(c192051214.tgtg)
	e1:SetOperation(c192051214.tgop)
	c:RegisterEffect(e1)
end
function c192051214.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c192051214.cfilter(c,g)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x617) and c:IsAbleToRemoveAsCost() and g:IsContains(c)
end
function c192051214.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c192051214.cfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetMaterial()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c192051214.cfilter,tp,LOCATION_GRAVE,0,1,65,nil,c:GetMaterial())
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c192051214.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()*500)
end
function c192051214.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local dam=Duel.Damage(p,d,REASON_EFFECT)
	local draw=math.floor(dam/1000)
	if draw>0 then
		Duel.Draw(tp,draw,REASON_EFFECT)
	end
end
