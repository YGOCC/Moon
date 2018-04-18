--created by LionHeartKIng, coded by Lyris, art at http://nicolelbates.com/wp-content/uploads/2012/07/Lightning-Bolt-by-Todd-Secki.jpg
--襲雷ラッシュ
function c240100038.initial_effect(c)
	--Destroy 3 face-up "Blitzkrieg" Pendulum cards with different names in your Pendulum Zones and/or Extra Deck, then draw 2 cards. You can only activate 1 "Blitzkrieg Rush" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,240100038+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c240100038.target)
	e1:SetOperation(c240100038.operation)
	c:RegisterEffect(e1)
end
function c240100038.filter(c)
	return c:IsSetCard(0x7c4) and c:IsType(TYPE_PENDULUM) and c:IsDestructable() and c:IsFaceup()
end
function c240100038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c240100038.filter,tp,LOCATION_EXTRA+LOCATION_PZONE,0,3,nil) end
	local g=Duel.GetMatchingGroup(c240100038.filter,tp,LOCATION_EXTRA+LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c240100038.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c240100038.filter,tp,LOCATION_EXTRA+LOCATION_PZONE,0,3,3,nil)
	if tg:GetCount()~=3 then return end
	local ct=Duel.Destroy(tg,REASON_EFFECT)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
