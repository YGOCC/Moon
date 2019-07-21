--Paracyclissavior of Future, Starrain
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local s,id=getID()

function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,3,false)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.material_setcode=0x308
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x308) and (c:GetLevel()>=8)
		and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function s.cfilter(c,fc)
	return c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc)
		and c:IsFusionSetCard(0x308) and (c:GetLevel()>=8)
end
function s.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(s.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:GetClassCount(Card.GetFusionCode)==3
	end
	sg:RemoveCard(c)
	return res
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(s.fselect,1,nil,tp,mg,sg)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,s.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoDeck(sg,nil,1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.cfilter(c)
	return c:IsSetCard(0x308) and c:IsAbleToGraveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):FilterCount(Card.IsFaceup,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	e:SetLabel(Duel.DiscardDeck(tp,ct,REASON_COST))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>#Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFaceup,nil) then return end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ng=tg:FilterSelect(tp,Card.IsFaceup,1,1,nil)
	Duel.ChangePosition(ng,POS_FACEDOWN_DEFENSE)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFacedown,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=e1:Clone()
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFaceup,nil)
	if #g>0 then Duel.BreakEffect() Duel.Destroy(g,REASON_EFFECT) end
end
