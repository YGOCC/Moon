--brave
function c100000874.initial_effect(c)
c:SetUniqueOnField(1,0,100000874)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x753),4,2)
	c:EnableReviveLimit()
	--Remove self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000874,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c100000874.sptg)
	e1:SetOperation(c100000874.spop)
	c:RegisterEffect(e1)
	--seother
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000874,1))
	e2:SetCountLimit(1,100000874)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c100000874.remcon)
	e2:SetTarget(c100000874.remtg)
	e2:SetOperation(c100000874.remop)
	c:RegisterEffect(e2)
	--remove grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1,100000874)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetDescription(aux.Stringid(100000874,2))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100000874.cost)
	e3:SetTarget(c100000874.targetg)
	e3:SetOperation(c100000874.operationg)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetOperation(c100000874.regop)
	c:RegisterEffect(e4)
	--dam
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetDescription(aux.Stringid(100000874,1))
	e21:SetCategory(CATEGORY_DAMAGE)
	e21:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1)
	e21:SetCondition(c100000874.damcon7)
	e21:SetTarget(c100000874.damtg7)
	e21:SetOperation(c100000874.damop7)
	c:RegisterEffect(e21)
	--atk
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(c100000874.atkval)
	c:RegisterEffect(e11)
	--defup
	local e9=e11:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
end
function c100000874.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),1,0)*100
end
function c100000874.damcon7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000874.damtg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,800)
end
function c100000874.damop7(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100000874.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000874)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c100000874.spop(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then end
		Duel.Remove(e:GetHandler(),nil,nil,REASON_EFFECT)
end
function c100000874.remcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT) and re:GetHandler():IsSetCard(0x753)
end
function c100000874.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000874.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100000874.filter(c)
	return c:IsSetCard(0x753) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100000874.remop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000874.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100000874.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFaceup() then
		e:GetHandler():RegisterFlagEffect(100000874,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c100000874.targetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()~=tp and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100000874.operationg(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then end
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
function c100000874.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end