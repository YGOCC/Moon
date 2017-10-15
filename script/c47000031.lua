--Digimon Armageddemon
function c47000031.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c47000031.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCondition(c47000031.sprcon)
	e2:SetOperation(c47000031.sprop)
	c:RegisterEffect(e2)
	--Special Summon 1 Token
  	local e3=Effect.CreateEffect(c)
  	e3:SetDescription(aux.Stringid(47000029,0))
  	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  	e3:SetType(EFFECT_TYPE_IGNITION)
  	e3:SetRange(LOCATION_MZONE)
  	e3:SetCountLimit(1)
  	e3:SetTarget(c47000029.tktg)
  	e3:SetOperation(c47000029.tkop)
  	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000031,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c47000031.destg1)
	e4:SetOperation(c47000031.desop1)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47000031,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c47000031.discon)
	e5:SetCost(c47000031.discost)
	e5:SetTarget(c47000031.distg)
	e5:SetOperation(c47000031.disop)
	c:RegisterEffect(e5)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(47000031,3))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetTarget(c47000031.thtg)
	e7:SetOperation(c47000031.thop)
	c:RegisterEffect(e7)
	end
function c47000031.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c47000031.spfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(47000029) and Duel.IsExistingMatchingCard(c47000031.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c47000031.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6E7) 
end
function c47000031.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c47000031.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c47000031.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47000031,0))
	local g1=Duel.SelectMatchingCard(tp,c47000031.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47000031,1))
	local g2=Duel.SelectMatchingCard(tp,c47000031.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,10,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--atk mod
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(g1:GetCount()*1000)
	c:RegisterEffect(e1)
	--def mod
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(g1:GetCount()*1000)
	c:RegisterEffect(e2)
end
function c47000029.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,47000032,0x3E4, 0x4011,400,300,1,RACE_FIEND,ATTRIBUTE_DARK) end
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47000029.tkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,47000032,0x3E4,0x4011,400,300,1,RACE_FIEND,ATTRIBUTE_DARK) then
  local token=Duel.CreateToken(tp,47000032)
  Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c47000031.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsFaceup() and tc:GetAttribute()~=ATTRIBUTE_LIGHT end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c47000031.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c47000031.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c47000031.costfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3E4) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c47000031.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000031.costfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c47000031.costfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end
function c47000031.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c47000031.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c47000031.thfilter(c)
	return c:IsCode(47000030) and c:IsAbleToHand()
end
function c47000031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c47000031.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47000031.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_GRAVE,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleDeck(tp)
	end
end

