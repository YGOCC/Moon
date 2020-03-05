--Moon's Dream: Child of Light
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cid.ponyfilter,2,true)
	aux.AddContactFusionProcedure(c,cid.ponyfilter,LOCATION_REMOVED,0,function(g) Duel.SendtoGrave(g:Filter(Card.IsSetCard,nil,0x666),REASON_MATERIAL) Duel.Exile(g:Filter(Card.IsCode,nil,104242585),REASON_RULE) end)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2956282,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.discon)
	e1:SetCost(cid.discost)
	e1:SetTarget(cid.distg)
	e1:SetOperation(cid.disop)
	c:RegisterEffect(e1)
	--banish as punishment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39823987,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(cid.destg)
	e2:SetOperation(cid.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cid.regcon)
	e2:SetOperation(cid.regop)
	c:RegisterEffect(e2)
end
function cid.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cid.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(39823987,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(cid.spcon)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetLabel(Duel.GetTurnCount())
	Duel.RegisterEffect(e1,tp)
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cid.spfilter(c,e,tp)
	return c:IsCode(id-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetFirstMatchingCard(cid.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if g then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--banish as punishment
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetReasonCard()
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
	
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local tc=e:GetHandler():GetReasonCard() or (e:GetHandler():GetReasonEffect() and e:GetHandler():GetReasonEffect():GetHandler())
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				Duel.Recover(tp,1000,REASON_EFFECT)
					local sc=Duel.CreateToken(tp,104242585)
						sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
							Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end
end

function cid.ponyfilter(c,fc,sub,mg,sg)
	if c:IsFacedown() or not c:IsCanBeFusionMaterial() then return false end
	if c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) then
		return not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsCode,1,c,104242585)
	elseif c:IsCode(104242585) then
		return not sg or not sg:IsExists(Card.IsCode,1,c,104242585)
	end
	return false
end
function cid.negcostfilter(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function cid.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function cid.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
