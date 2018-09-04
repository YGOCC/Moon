--最終ゴブリングパイ
function c2101997261.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c2101997261.target)
	e1:SetOperation(c2101997261.activate)
	c:RegisterEffect(e1)
	--Turn Counter Add
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_REMOVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c2101997261.tncon)
    e2:SetOperation(c2101997261.tnop)
    c:RegisterEffect(e2)
	--Draw after 5
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetOperation(c2101997261.activate)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_CUSTOM+210424265)
    e3:SetCost(card.descost)
    e3:SetTarget(card.destg)
    e3:SetOperation(card.desop)
    c:RegisterEffect(e3)
end
--Activate
function c2101997261.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil)==1 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c2101997261.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>1 then ct=1 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
--Turn Counter Add
function c2101997261.rfilter(c,tp)
    return c:IsFacedown() and c:GetPreviousLocation()==LOCATION_DECK and c:IsControler(tp)
end
function c2101997261.tncon(e,tp,eg,ep,ev,re,r,rp)
    return rp==tp and eg:IsExists(c2101997261.rfilter,1,nil,tp)
end
function c2101997261.tnop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(c2101997261.rfilter,nil)
    for i=1,ct do
        Duel.MoveTurnCount()
    end
end
--Draw after 5
function c2101997261.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,95308449)~=0 then return end
	Duel.RegisterFlagEffect(tp,95308449,0,0,0)
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c2101997261.checkop)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,5)
	c2101997261[c]=e1
end
function c2101997261.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	 if ct==5 then
    Duel.RaiseSingleEvent(c,EVENT_CUSTOM+210424265,re,0,0,p,0)
	end
	
end
