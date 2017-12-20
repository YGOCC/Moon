--//CodeRed
function c221812214.initial_effect(c)
	--When a "Viravolve" monster you control is destroyed by battle and sent to the GY: Shuffle the destroyed monster into the Deck; draw 1 card, and if the drawn card is a Level 1 monster, you can Special Summon it.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c221812214.condition)
	e1:SetCost(c221812214.cost)
	e1:SetTarget(c221812214.target)
	e1:SetOperation(c221812214.activate)
	c:RegisterEffect(e1)
	--If this card is sent to the GY by an opponent's card or effect: destroy 1 card on the field and inflict 100 damage to its controller.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c221812214.descon)
	e2:SetTarget(c221812214.destg)
	e2:SetOperation(c221812214.desop)
	c:RegisterEffect(e2)
end
function c221812214.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsSetCard(0xa67)
end
function c221812214.condition(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg:GetFirst())
	return eg:IsExists(c221812214.cfilter,1,nil,tp)
end
function c221812214.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c221812214.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c221812214.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	if dc:GetLevel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and dc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(221812214,0)) then
		Duel.ConfirmCards(1-tp,dc)
		Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c221812214.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c221812214.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c221812214.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local p=tc:GetControler()
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.Damage(p,100,REASON_EFFECT)
	end
end
