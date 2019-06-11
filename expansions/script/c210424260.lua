--Moon Burst: The Little Harbinger
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
local id2=id+1000000
function cid.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--AtkSteal
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.atktg)
	e1:SetOperation(cid.atkop)
	c:RegisterEffect(e1)
	--AtkSteal (Quick Effect during Chain)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_QUICK_O)
	e1x:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1x:SetCode(EVENT_FREE_CHAIN)
	e1x:SetRange(LOCATION_PZONE)
	e1x:SetCountLimit(1,id)
	e1x:SetCondition(cid.atkcon_quick)
	e1x:SetTarget(cid.atktg)
	e1x:SetOperation(cid.atkop)
	c:RegisterEffect(e1x)
	--AtkSteal (Battle Trigger)
--	local e2=e1:Clone()
--	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
--	e2:SetCode(EVENT_BE_BATTLE_TARGET)
--	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
--	e2:SetCondition(cid.battlecon)
--	c:RegisterEffect(e2)
	--AtkSteal (Chain Trigger)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	e3:SetCondition(cid.checkchain)
	e3:SetOperation(cid.setchain)
	c:RegisterEffect(e3)
		--swap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4066,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id+1000)
	e4:SetTarget(cid.swaptg)
	e4:SetOperation(cid.swapop)
	c:RegisterEffect(e4)
	--On target, destroy spell/trap
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+1000)
	e5:SetCondition(cid.betarget)
	e5:SetTarget(cid.destg2)
	e5:SetOperation(cid.desop2)
	c:RegisterEffect(e5)
	--Art swap
	local exx=Effect.CreateEffect(c)
	exx:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	exx:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx:SetCode(EVENT_ADJUST)
	exx:SetRange(LOCATION_MZONE)
	exx:SetCondition(cid.artcon)
	exx:SetOperation(cid.artop)
	c:RegisterEffect(exx)
	--Art swap
	local exx2=Effect.CreateEffect(c)
	exx2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	exx2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx2:SetCode(EVENT_ADJUST)
	exx2:SetRange(LOCATION_MZONE)
	exx2:SetCondition(cid.artcon2)
	exx2:SetOperation(cid.artop2)
	c:RegisterEffect(exx2)
end
--filters
function cid.pendfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function cid.desfilter2(c)
 return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cid.atkstealfilter(c,e)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function cid.swapatkstealfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
function cid.swapfilter2(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
--Battle Trigger
function cid.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x666)
end
--Chain Trigger
function cid.checkchain(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.pendfilter,1,nil,tp)
end
function cid.setchain(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
end
--AtkSteal (Operation)
function cid.atkcon_quick(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function cid.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return 
	Duel.IsExistingTarget(cid.atkstealfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and
	Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	local g2=Duel.SelectTarget(tp,cid.atkstealfilter,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
	local atk=hc:GetAttack()
	local atk2=tc:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(-atk/2)
	hc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetValue(-atk2/2)
	tc:RegisterEffect(e2)
end
end
--Destroy on target
function cid.betarget(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return eg:IsContains(e:GetHandler()) and re and re:GetOwner()~=c
end
function cid.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and cid.desfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.desfilter2,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cid.desfilter2,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
end
end
--swap
function cid.swaptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and cid.swapatkstealfilter(chkc,e,tp))
	and (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.swapfilter2(chkc,e,tp)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(cid.swapfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
	and Duel.IsExistingMatchingCard(cid.swapatkstealfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(42378577,2))
	local g=Duel.SelectTarget(tp,cid.swapfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cid.swapop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,cid.swapatkstealfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and
	not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	if not Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
end
end
end
--Art swap
function cid.artcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
  return (c:GetOriginalCode()==id or c:GetOriginalCode()==id2) and
  e:GetHandler():GetAttack()>=c:GetTextAttack()+1000
end
function cid.artop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=id2
	c:SetEntityCode(tcode,true)
	--c:ReplaceEffect(tcode,0,0)
	--	Duel.SetMetatable(c,_G["c"..tcode])
end
function cid.artcon2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
  return (c:GetOriginalCode()==id or c:GetOriginalCode()==id2) and 
  e:GetHandler():GetAttack()<c:GetTextAttack()+1000
end
function cid.artop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=id
	c:SetEntityCode(tcode,true)
--	c:ReplaceEffect(tcode,0,0)
--	Duel.SetMetatable(c,_G["c"..tcode])
end