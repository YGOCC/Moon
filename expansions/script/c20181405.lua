--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cid.splimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCondition(aux.PandActCheck)
	e5:SetCost(cid.cost)
	e5:SetTarget(cid.sptg)
	e5:SetOperation(cid.spop)
	c:RegisterEffect(e5)
	aux.EnablePandemoniumAttribute(c,e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cid.spcon)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+5)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetTarget(cid.target)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_DINOSAUR) then return false end
	return bit.band(sumtype,SUMMON_TYPE_SPECIAL+726)==SUMMON_TYPE_SPECIAL+726
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cid.spcfilter(c,e,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x9b5) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM+TYPE_PENDULUM) or c:IsOnField()) and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_DECK,0,1,c,e,tp,c:GetCode())
end
function cid.spfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x9b5) and not c:IsCode(code)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cid.spcfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.spcfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabelObject():GetCode())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cid.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM+TYPE_PENDULUM) and c:IsSetCard(0x9b5)
end
function cid.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER),Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
	Duel.Damage(p,d*300,REASON_EFFECT)
end
