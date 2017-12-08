--Paintress ARMANIA
function c16000538.initial_effect(c)
--pendulum summon
	 --Pendulum Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,16000538)
	e1:SetCondition(aux.PendCondition())
	e1:SetOperation(aux.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c16000538.target)
	e2:SetOperation(c16000538.activate)
	c:RegisterEffect(e2)
	end
  local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16000538,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,1600053811)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c16000538.spcon)
	e5:SetTarget(c16000538.sptg)
	e5:SetOperation(c16000538.spop)
	c:RegisterEffect(e5)
end
function c16000538.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end

function c16000538.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	 Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.Recover(p,500,REASON_EFFECT)

end
function c16000538.cfilter2(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and not c:IsSetCard(TYPE_MONSTER) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c16000538.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16000538.cfilter2,1,nil,tp)
end
function c16000538.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c16000538.spop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end