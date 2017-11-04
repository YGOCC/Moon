--Blast Fenix
local ref=_G['c'..18917021]
function ref.initial_effect(c)
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
	
	--Burn
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,18917021)
	e1:SetTarget(ref.damtg)
	e1:SetOperation(ref.damop)
	c:RegisterEffect(e1)
	--Revive
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(ref.sscon)
	e2:SetCost(ref.sscost)
	e2:SetTarget(ref.sstg)
	e2:SetOperation(ref.ssop)
	c:RegisterEffect(e2)
end

ref.bloom = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end
function ref.material(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end

function ref.damfilter(c)
	return c.seedling and c:GetLevel()>0
end
function ref.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.damfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,ref.damfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetLevel()*300)
end
function ref.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetLevel()>0 then
		Duel.Damage(1-tp,tc:GetLevel()*300,REASON_EFFECT)
	end
end

function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function ref.sscfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function ref.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.sscfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.sscfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
