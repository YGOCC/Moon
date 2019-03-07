--Naturia Monokeros
function c212185.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2a),c212185.matfilter,1,63,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c212185.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c212185.sprcon)
	e2:SetOperation(c212185.sprop)
	c:RegisterEffect(e2)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	c:RegisterEffect(e2)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c212185.efilter)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(212185,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c212185.target)
	e5:SetOperation(c212185.operation)
	c:RegisterEffect(e5)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetTargetRange(1,0)
	e6:SetCondition(c212185.splimcon)
	e6:SetTarget(c212185.splimit)
	c:RegisterEffect(e6)
end
c212185.material_setcode=0x2a
function c212185.matfilter(c)
	return c:GetSequence()>4
end
function c212185.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_Extra
end
function c212185.cfilter(c,tp)
	return (c:IsFusionSetCard(0x2a) or c:GetSequence()>4) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c212185.fcheck(c,sg)
	return c:IsFusionSetCard(0x2a) and c:IsType(TYPE_MONSTER) and sg:FilterCount(c212185.fcheck2,c)+1==sg:GetCount()
end
function c212185.fcheck2(c)
	return c:GetSequence()>4
end
function c212185.fgoal(c,tp,sg)
	return #sg>1 and #sg<=3 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c212185.fcheck,1,nil,sg)
end
function c212185.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c212185.fgoal(c,tp,sg) or mg:IsExists(c212185.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c212185.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c212185.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c212185.fselect,1,nil,tp,mg,sg)
end
function c212185.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c212185.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c212185.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c212185.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.SendtoGrave(sg,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(sg:GetCount()*1500)
	c:RegisterEffect(e1)
end
function c212185.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c212185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c212185.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c212185.splimcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>0
end