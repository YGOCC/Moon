--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigPandemoniumType(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cid.pslimit)
	c:RegisterEffect(e4)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(aux.PandActCheck)
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetTarget(cid.sptg)
	e0:SetOperation(cid.spop)
	c:RegisterEffect(e0)
	aux.EnablePandemoniumAttribute(c,e0,true,TYPE_EFFECT+TYPE_FUSION)
	aux.AddFusionProcCodeFunRep(c,id-3,aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR),1,63,true,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cid.sprcon)
	e4:SetOperation(cid.sprop)
	e4:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(cid.splimit)
	c:RegisterEffect(e6)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCondition(function(e,tp,eg) return eg:IsExists(cid.filter,1,nil) end)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.destg)
	e3:SetOperation(cid.desop)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCondition(cid.condition)
	e7:SetTarget(cid.pentg)
	e7:SetOperation(cid.penop)
	c:RegisterEffect(e7)
end
function cid.cmfilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function cid.sprcon(e,c)
	if c==nil then return true end
	if c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cid.cmfilter,tp,LOCATION_MZONE,0,c,c)
	return c:CheckFusionMaterial(mg,nil,tp)
end
function cid.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cid.cmfilter,tp,LOCATION_MZONE,0,c,c)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cid.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cid.pslimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_DINOSAUR) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PANDEMONIUM)==SUMMON_TYPE_PANDEMONIUM
end
function cid.tgfilter(c,e,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x9b5) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function cid.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x9b5)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_DECK,0,1,1,tc,e,tp)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cid.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0 end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local d=Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	if d==0 or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(d)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
end
function cid.filter(c)
	return c:IsSetCard(0x9b5) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(500)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cid.cfilter(c,tp,code)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x9b5) and c:IsType(TYPE_MONSTER)
		and (not code and Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_DECK,0,1,c,tp,{c:GetCode()}) or not c:IsCode(table.unpack(code)))
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_DECK,0,1,1,tc,tp,{tc:GetCode()})
	Duel.SendtoGrave(g1+g2,REASON_EFFECT)
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cid.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and aux.PandSSetCon(e:GetHandler(),nil,e:GetHandler():GetLocation(),e:GetHandler():GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp) end
end
function cid.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and aux.PandSSetCon(e:GetHandler(),nil,e:GetHandler():GetLocation(),e:GetHandler():GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp) then
		aux.PandSSet(c,REASON_EFFECT,TYPE_EFFECT+TYPE_FUSION)(e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,c)
	end
end
