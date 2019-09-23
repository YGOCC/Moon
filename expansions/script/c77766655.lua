--BF－黒槍のブラスト
local m=77766655
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(cm.efcon)
	e2:SetOperation(cm.efop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x70) and c:GetCode()~=m
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc:IsFaceup() and rc:IsSummonType(SUMMON_TYPE_XYZ) then
		--Treat as Chronomaly
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(0x70)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1)
		--Destroy self to sp summon Chronomaly
		local e3=Effect.CreateEffect(rc)
	    e3:SetDescription(aux.Stringid(77766655,0))
	    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	    e3:SetType(EFFECT_TYPE_QUICK_O)
	    e3:SetCode(EVENT_FREE_CHAIN)
	    e3:SetRange(LOCATION_MZONE)
	    e3:SetCost(cm.cost)
	    e3:SetTarget(cm.destg)
	    e3:SetOperation(cm.desop)
	    e3:SetReset(RESET_EVENT+0x1fe0000)
	    rc:RegisterEffect(e3,false,1)
    end
    if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e)  then
	    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	    if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then 
		    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		    if g:GetCount()>0 then
			    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		    end
	    end
    end
end