--Paintress-Ama Archfiend Goghi
function c16000443.initial_effect(c)
   --link summon
	aux.AddLinkProcedure(c,nil,2,99,c16000443.lcheck)
	c:EnableReviveLimit()
  --special summon
	--local e0=Effect.CreateEffect(c)
	--e0:SetType(EFFECT_TYPE_FIELD)
	--e0:SetDescription(aux.Stringid(6666,6))
	--e0:SetCode(EFFECT_SPSUMMON_PROC)
	--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e0:SetRange(LOCATION_EXTRA)
	--e0:SetCondition(c16000443.spcon)
	--e0:SetOperation(c16000443.spop)
	--e0:SetValue(SUMMON_TYPE_LINK)
	--c:RegisterEffect(e0)
   --cannot be target/battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c16000443.tgtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16000443,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c16000443.tdcon)
	e3:SetTarget(c16000443.tdtg)
	e3:SetOperation(c16000443.tdop)
	c:RegisterEffect(e3)
end
function c16000443.mfilter(c)
	return  not c:IsLinkType(TYPE_EFFECT)
end
function c16000443.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xc50)
end
function c16000443.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc50) and c:IsAbleToRemoveAsCost()
end
function c16000443.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000443.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,nil)
end
function c16000443.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16000443.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_LINK)
	e:GetHandler():SetMaterial(g:Filter(Card.IsLocation,nil,LOCATION_REMOVED))
end
function c16000443.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c16000443.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c16000443.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c16000443.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0):Filter(c16000443.filter,nil,c:GetMaterial())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	Duel.Recover(tp,ct*300,REASON_EFFECT)
	
	end
end
function c16000443.filter(c,mg)
	return not mg:IsContains(c)
end
