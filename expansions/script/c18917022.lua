--Shiranui Soulspeaker
local ref=_G['c'..18917022]
function ref.initial_effect(c)
	--Bloom Condition
	local be1=Effect.CreateEffect(c)
	be1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	be1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	be1:SetRange(LOCATION_MZONE)
	be1:SetCode(EVENT_REMOVE)
	be1:SetCondition(ref.bloomcon)
	be1:SetOperation(ref.bloomop)
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
	
	--Procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18917022)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end

ref.seedling = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end

function ref.bloomfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function ref.bloomcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.bloomfilter,1,nil,tp)
end
function ref.bloomop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(269,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(269)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end


function ref.spfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function ref.thfilter(c)
	return c:IsSetCard(0xd9) and c:IsType(TYPE_MONSTER) and not c:IsCode(18917022)
		and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
