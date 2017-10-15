--32083000
function c32083000.initial_effect(c)
	c:EnableReviveLimit()
--cannot special summon
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
e1:SetCode(EFFECT_SPSUMMON_CONDITION)
e1:SetValue(aux.FALSE)
c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c32083000.atkop)
	c:RegisterEffect(e3)
--special summon
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_IGNITION)
e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
e2:SetRange(LOCATION_REMOVED)
e2:SetCondition(c32083000.spcon)
e2:SetOperation(c32083000.spop)
e2:SetLabelObject(e3)
c:RegisterEffect(e2)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c32083000.disop)
	c:RegisterEffect(e4)
--destroy replace
local e5=Effect.CreateEffect(c)
e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e5:SetRange(LOCATION_MZONE)
e5:SetCode(EFFECT_DESTROY_REPLACE)
e5:SetTarget(c32083000.desreptg)
c:RegisterEffect(e5)
	--banish+damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(32083000,0))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c32083000.destg)
	e6:SetOperation(c32083000.desop)
	c:RegisterEffect(e6)
		--banish replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SEND_REPLACE)
	e7:SetTarget(c32083000.bantg)
	c:RegisterEffect(e7)
end
function c32083000.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsType(TYPE_MONSTER) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
	end
end
function c32083000.filter(c)
return c:IsSetCard(0x7D53) and c:IsFaceup()
end
function c32083000.spcon(e,c)
local c=e:GetHandler()
return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
Duel.IsExistingMatchingCard(c32083000.filter,c:GetControler(),LOCATION_REMOVED,0,3,e:GetHandler())
end
function c32083000.spop(e,tp,eg,ep,ev,re,r,rp,c)
local c=e:GetHandler()
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=Duel.SelectMatchingCard(tp,c32083000.filter,tp,LOCATION_REMOVED,0,3,3,e:GetHandler())
Duel.SendtoGrave(g,REASON_COST)
Duel.Remove(g,POS_FACEDOWN,REASON_COST)
local sum=0
local tc=g:GetFirst()
while tc do
local lv=tc:GetLevel()
sum=sum+lv
tc=g:GetNext()
end
e:GetLabelObject():SetLabel(sum*500)
Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function c32083000.atkop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_BASE_ATTACK)
e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e1:SetRange(LOCATION_MZONE)
e1:SetValue(e:GetLabel())
e1:SetReset(RESET_EVENT+0x1ff0000)
c:RegisterEffect(e1)
end
function c32083000.rfilter(c)
return c:IsSetCard(0x7D53) and c:IsAbleToRemove()
end
function c32083000.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return not c:IsReason(REASON_REPLACE)
and Duel.IsExistingMatchingCard(c32083000.rfilter,tp,LOCATION_GRAVE,0,1,nil,nil)
end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
local g=Duel.SelectMatchingCard(tp,c32083000.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,nil)
Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
return true
end
function c32083000.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local a1=e:GetHandler():GetAttack()
	local a2=Duel.GetFirstTarget():GetAttack()
	local dam=a1-a2
	if dam<0 then dam=-dam end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,dam)
end
function c32083000.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
end
function c32083000.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_REMOVED or c:GetDestination()==LOCATION_TOHAND or c:GetDestination()==LOCATION_TODECK end
if chk==0 then return not c:IsReason(REASON_REPLACE)
and Duel.IsExistingMatchingCard(c32083000.rfilter,tp,LOCATION_GRAVE,0,1,nil,nil)
end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
local g=Duel.SelectMatchingCard(tp,c32083000.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,nil)
Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
return true
end