--Moon Burst: The Keyblade's Chosen
local card = c210424278
function card.initial_effect(c)
	c:SetUniqueOnField(1,0,210424278)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x666),2)
	c:EnableReviveLimit()
	--If kill by battle, grab card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71106375,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(card.thcon)
	e1:SetTarget(card.thtg)
	e1:SetOperation(card.thop)
	c:RegisterEffect(e1)
	--send to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4066,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(card.cost)
	e2:SetTarget(card.rtg)
	e2:SetOperation(card.rop)
	c:RegisterEffect(e2)
		--Return from death
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4591250,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(card.sptg)
	e3:SetOperation(card.spop)
	c:RegisterEffect(e3)
		local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
		--reborn
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetProperty(EFFECT_EXTRA_TOMAIN_KOISHI)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetCondition(card.spcon2)
	e5:SetOperation(card.spop2)
	c:RegisterEffect(e5)
	end
--filters
function card.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function card.repfilter(c,e)
	return c:IsSetCard(0x666) and c:IsFaceup()
		and c:IsAbleToRemove()
end
function card.repfilter2(c,e)
	return  c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x666)
end
function card.pendfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function card.swapfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
function card.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
	and Duel.IsExistingMatchingCard(card.filter2,tp,LOCATION_REMOVED,0,1,nil,code,e,tp)
end
function card.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--Shuffle 2; deck target
function card.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(card.repfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,card.repfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,nil,2,REASON_COST)
end
function card.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return 
	Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_TODECK)
	local g2=Duel.SelectTarget(tp,TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end
function card.rop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if tg1:GetFirst():IsRelateToEffect(e) then
		Duel.Destroy(tg1,REASON_EFFECT)
	end
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoDeck(tg2,nil,1,REASON_EFFECT)
	end
end
--If kill by battle, grab card
function card.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function card.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(card.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end
end
function card.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,card.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end	
--After death, return to field	
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(card.repfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end

end
function card.spop(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.SelectMatchingCard(tp,card.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(210424278,RESET_EVENT+RESETS_STANDARD,0,0)
end
function card.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffect(210424278)>0
end
function card.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:ResetFlagEffect(210424278)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e1:SetLabelObject(c)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetTarget(card.debugtofield)
	Duel.RegisterEffect(e1,tp)
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	e1:Reset()
end
function card.debugtofield(e,c,sump,sumtype,sumpos,targetp,se)
    return c==e:GetLabelObject()
end