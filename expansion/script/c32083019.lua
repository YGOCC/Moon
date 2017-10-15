--D.D. Rapture
function c32083019.initial_effect(c)
--banish
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_REMOVE)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c32083019.target)
e1:SetOperation(c32083019.activate)
c:RegisterEffect(e1)
end
function c32083019.filter(c)
return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7D53)
end
function c32083019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
   if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
   local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c32083019.activate(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local tc=Duel.GetFirstTarget()
   local lv=tc:GetLevel()
   local g=Duel.SelectTarget(tp,c32083019.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,lv,lv,nil)
   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end