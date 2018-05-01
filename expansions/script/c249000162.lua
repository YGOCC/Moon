--Defender Mecha - Twin Star
function c249000162.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,249000160,249000161,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c249000162.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27346636,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c249000162.sprcon)
	e2:SetOperation(c249000162.sprop)
	e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	-- indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c249000162.reptg)
	c:RegisterEffect(e4)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(16898077,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c249000162.descost)
	e6:SetTarget(c249000162.destg)
	e6:SetOperation(c249000162.desop)
	c:RegisterEffect(e6)
end
function c249000162.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c249000162.cfilter(c)
	return (c:IsFusionCode(249000160) or c:IsFusionCode(249000161)) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial()
end
function c249000162.spfilter1(c,tp,g)
	return g:IsExists(c249000162.spfilter2,1,c,tp,c)
end
function c249000162.spfilter2(c,tp,mc)
	return (c:IsFusionCode(249000160) and c:IsType(TYPE_MONSTER) and mc:IsFusionCode(249000161) and mc:IsType(TYPE_MONSTER))
		or (c:IsFusionSetCard(249000161) and c:IsType(TYPE_MONSTER) and mc:IsFusionCode(249000160) and mc:IsType(TYPE_MONSTER))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c249000162.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c249000162.cfilter,nil,c)
	return g:IsExists(c249000162.spfilter1,1,nil,tp,g)
end
function c249000162.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(c249000162.cfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c249000162.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:FilterSelect(tp,c249000162.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c249000162.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPosition(POS_FACEUP) end
	return true
end
function c249000162.filter(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsAbleToRemove()
end
function c249000162.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c249000162.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000162.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c249000162.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000162.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c249000162.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c249000162.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000162.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end