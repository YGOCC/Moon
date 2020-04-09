--"Ronin Mifune, the Shadow Manipulator"
--Scripted by 'Márcio Eduine'
function c90872.initial_effect(c)
	--Synchro Materials
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x5ab),2)
	c:EnableReviveLimit()
	--Gain LP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90872,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,90872)
	e1:SetTarget(c90872.rettg)
	e1:SetOperation(c90872.retop)
	c:RegisterEffect(e1)
	--Inflict Damage
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(90872,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90872,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,90872)
	e3:SetCost(c90872.cost)
	e3:SetTarget(c90872.sptg)
	e3:SetOperation(c90872.spop)
	c:RegisterEffect(e3)
end
function c90872.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(22201234)==0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,5) end
	e:GetHandler():RegisterFlagEffect(22201234,RESET_CHAIN,0,1)
	Duel.DiscardDeck(tp,5,REASON_COST)
end
function c90872.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function c90872.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x5ab) and c:IsType(TYPE_MONSTER)
end
function c90872.retop(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c90872.filter,nil)
	if ct>0 then
		if e:IsHasCategory(CATEGORY_DAMAGE) then 
		  Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		elseif e:IsHasCategory(CATEGORY_RECOVER) then
		  Duel.Recover(tp,ct*500,REASON_EFFECT)
		end
	end
end
function c90872.filter2(c,e,tp)
	return (not c:IsCode(90872)) and c:IsSetCard(0x5ab) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90872.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c90872.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c90872.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c90872.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90872.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end