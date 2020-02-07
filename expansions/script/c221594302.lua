--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(cid.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetTarget(cid.rttg)
	e1:SetOperation(cid.rtop)
	c:RegisterEffect(e1)
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cid.rmcon)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetTarget(cid.target)
	e5:SetOperation(cid.operation)
	c:RegisterEffect(e5)
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc97) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cid.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc97) and c:IsAbleToDeck()
end
function cid.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cid.filter1(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingTarget(cid.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if not tg or not tg:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cid.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,LOCATION_MZONE,0,1,nil)
		and tp~=ep and Duel.GetCurrentChain()==0 and #eg==1 and tc:GetSummonLocation()==LOCATION_EXTRA
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.BreakEffect()
	Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsForbidden() then return end
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if b1 and Duel.SelectOption(tp,1160,1105)==0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SelectOption(tp,1105)
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
