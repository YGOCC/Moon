--Golden Dragon of Judgment
local cod,id=c58745952,58745952
function cod.initial_effect(c)
	c:EnableReviveLimit()
	--Spsummon Condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cod.splimit)
	c:RegisterEffect(e1)
	--Spsummon Rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cod.sprcon)
	e2:SetOperation(cod.sprop)
	c:RegisterEffect(e2)
	--Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,3))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(cod.destg)
    e3:SetOperation(cod.desop)
    c:RegisterEffect(e3)
	--Replace
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(cod.reptg)
    e4:SetOperation(cod.repop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_SEND_REPLACE)
    c:RegisterEffect(e5)
end
function cod.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cod.spfilter1(c,tp)
	return c:IsFusionCode(57774843) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(cod.spfilter2,tp,LOCATION_MZONE,0,3,nil)
end
function cod.spfilter2(c)
	return c:IsFusionSetCard(0x38) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function cod.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cod.spfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,2,nil,tp)
end
function cod.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g1=Duel.SelectMatchingCard(tp,cod.spfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g2=Duel.SelectMatchingCard(tp,cod.spfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,3,3,nil)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function cod.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cod.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct==0 then return end
    Duel.BreakEffect()
    Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
function cod.rpfilter(c,e,tp)
	return c:IsCode(57774843) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function cod.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsAbleToExtra()
    	and Duel.IsExistingMatchingCard(cod.rpfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
        return true
    else return false end
end
function cod.repop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cod.rpfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
    if g:GetCount()>0 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   		local sg=g:Select(tp,1,1,nil)
    	if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)~=0 then
    		Duel.BreakEffect()
    		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
    	end
    end
end