--Plague Pod
local ref=_G['c'..18917020]
function ref.initial_effect(c)
	--Bloom Condition
	local be1=Effect.CreateEffect(c)
	be1:SetDescription(aux.Stringid(269,0))
	be1:SetType(EFFECT_TYPE_SINGLE)
	be1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	be1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	be1:SetCode(269)
	be1:SetCondition(ref.bloomcon)
	c:RegisterEffect(be1)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
	
	--Type/Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(ref.attcost)
	e1:SetOperation(ref.attop)
	c:RegisterEffect(e1)
	--Grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(ref.grcon)
	e3:SetTarget(ref.grtg)
	e3:SetOperation(ref.grop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end

ref.seedling = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end

function ref.bloomfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function ref.bloomcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(ref.bloomfilter,tp,0,LOCATION_MZONE,1,nil)
end

function ref.attcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function ref.attop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(RACE_ZOMBIE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	Duel.RegisterEffect(e2,tp)
end

function ref.grcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function ref.grfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function ref.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.grfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
