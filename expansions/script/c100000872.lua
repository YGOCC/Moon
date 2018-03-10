--fieldsp
function c100000872.initial_effect(c)
c:SetUniqueOnField(1,0,100000872)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x753),2,true)
		--spsummon condition
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e11)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000872,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c100000872.sptg)
	e1:SetOperation(c100000872.spop)
	c:RegisterEffect(e1)
	--seother
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000872,1))
	e2:SetCountLimit(1,100000872)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c100000872.remcon)
	e2:SetTarget(c100000872.remtg)
	e2:SetOperation(c100000872.remop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetOperation(c100000872.regop)
	c:RegisterEffect(e3)
		--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000872,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,100000872)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c100000872.rmtgr)
	e5:SetOperation(c100000872.rmopr)
	c:RegisterEffect(e5)
		--spsummon condition
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c100000872.splimit)
	c:RegisterEffect(e6)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c100000872.sprcon)
	e7:SetOperation(c100000872.sprop)
	c:RegisterEffect(e7)
			--atkup
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c100000872.val)
	c:RegisterEffect(e8)
		--defup
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
	--dam
		local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetDescription(aux.Stringid(100000872,1))
	e21:SetCategory(CATEGORY_DAMAGE)
	e21:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1)
	e21:SetCondition(c100000872.damcon7)
	e21:SetTarget(c100000872.damtg7)
	e21:SetOperation(c100000872.damop7)
	c:RegisterEffect(e21)
end
function c100000872.damcon7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000872.damtg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,800)
end
function c100000872.damop7(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100000872.val(e,c)
	return Duel.GetMatchingGroupCount(c100000872.vfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end
function c100000872.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER)
end
function c100000872.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c100000872.spfilter(c)
	return c:IsSetCard(0x753) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c100000872.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c100000872.spfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c100000872.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100000872.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.SendtoGrave(g,nil,2,REASON_COST)
end

function c100000872.filterrgr(c)
	return  c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100000872.rmtgr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000872.filterrgr,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c100000872.rmopr(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000872.filterrgr,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then  end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
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
function c100000872.coffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER)
end
function c100000872.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFaceup() then
		e:GetHandler():RegisterFlagEffect(100000872,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c100000872.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000872)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c100000872.spop(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then end
		Duel.Remove(e:GetHandler(),nil,nil,REASON_EFFECT)
end
function c100000872.remcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT) and re:GetHandler():IsSetCard(0x753)
end
function c100000872.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000872.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c100000872.filter(c)
	return c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(100000872)
end
function c100000872.remop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000872.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end