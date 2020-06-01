--Corrupt Runefall Enchanter
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cid=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cid
end
local id,cid=getID()
function cid.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x522),2,true)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(cid.sprcon)
	e0:SetOperation(cid.sprop)
	c:RegisterEffect(e0)  
	--Reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.tdcon)
	e1:SetOperation(cid.tdop)
	c:RegisterEffect(e1)
	--sset
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+100)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e4:SetTarget(cid.settg)
	e4:SetOperation(cid.setop)
	c:RegisterEffect(e4)
end
function cid.matfilter(c)
	return c:IsSetCard(0x522) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
end
function cid.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cid.matfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(cid.matfilter,1,nil,tp,g)
end
function cid.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cid.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cid.matfilter,2,2,nil,tp,g)
	--local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	--local g2=g:FilterSelect(tp,cm.spfilter2,1,1,mc,tp,mc)
	--g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cid.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cid.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(-1000)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0x522) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cid.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=e:GetHandler()
	if tc then
		local typ=tc:GetOriginalType()
		if tc:IsSSetable() then
			tc:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
			Duel.SSet(tp,tc)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
			--reset trap status
			local res=Effect.CreateEffect(e:GetHandler())
			res:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			res:SetCode(EVENT_ADJUST)
			res:SetLabel(typ)
			res:SetLabelObject(tc)
			res:SetCondition(cid.rescon)
			res:SetOperation(cid.reset)
			Duel.RegisterEffect(res,tp)
			--negate
			local e3=Effect.CreateEffect(c)
			e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
			e3:SetType(EFFECT_TYPE_ACTIVATE)
			e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e3:SetCode(EVENT_CHAINING)
			e3:SetCondition(cid.negcon)
			e3:SetCost(cid.negcost)
			e3:SetTarget(cid.negtg)
			e3:SetOperation(cid.negop)
			c:RegisterEffect(e3)
		end
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc1=g:GetFirst()
	if tc1 then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	end
end
--reset trap status
function cid.rescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)<=0
end
function cid.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetCardData(CARDDATA_TYPE,e:GetLabel())
	e:Reset()
end
--Negate Monster
function cid.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cid.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x522) and (c:IsControler(tp) or c:IsFaceup())
end
function cid.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cid.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,cid.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function cid.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
