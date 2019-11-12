--I.I.I. Colonel Hymenoptera
function c201001002.initial_effect(c)
	--You can Tribute 3 monsters or 1 "I.I.I." monster to Tribute Summon (but not Set) this card. This card gains effects based on the number of monsters used for its Tribute Summon. (below)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(201001002,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c201001002.ttcon)
	e1:SetOperation(c201001002.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(201001002,1))
	e2:SetCondition(c201001002.otcon)
	e2:SetOperation(c201001002.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE+2)
	c:RegisterEffect(e2)
	--2+: Once per turn, when your opponent activates a monster effect (Quick Effect): You can negate the activation, and if you do, destroy it.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c201001002.matcheck)
	c:RegisterEffect(e0)
end
function c201001002.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c201001002.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end
function c201001002.matcheck(e,c)
	if not c:IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	local ct=c:GetMaterialCount()
	if ct>0 then
		--1+: Once per turn: You can target 1 "I.I.I." monster in your GY; add it to your hand.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetTarget(c201001002.thtg)
		e1:SetOperation(c201001002.thop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
	if ct>1 then
		--2+: Once per turn, when your opponent activates a monster effect (Quick Effect): You can negate the activation, and if you do, destroy it.
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_CHAINING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e3:SetCondition(c201001002.negcon)
		e3:SetTarget(c201001002.negtg)
		e3:SetOperation(c201001002.negop)
		e3:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e3)
	end
	if ct==3 then
		--3: If this card is Tribute Summoned: You can destroy all monsters your opponent controls
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(201001002,1))
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetTarget(c201001002.destg)
		e2:SetOperation(c201001002.desop)
		e2:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e2)
	end
end
function c201001002.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdbd) and c:IsAbleToHand()
end
function c201001002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c201001002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c201001002.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c201001002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c201001002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c201001002.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c201001002.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c201001002.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c201001002.otfilter(c,tp)
	return c:IsSetCard(0xdbd) and (c:IsControler(tp) or c:IsFaceup())
end
function c201001002.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c201001002.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c201001002.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c201001002.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)
end
function c201001002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil)
end
function c201001002.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
