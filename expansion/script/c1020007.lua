--Coded-Eyes Machina Dragon
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(scard.otcon)
	e1:SetOperation(scard.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(scard.target)
	e2:SetCountLimit(1,s_id+10000000)
	e2:SetOperation(scard.operation)
	c:RegisterEffect(e2)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(scard.atkcost)
	e4:SetTarget(scard.atktarget)
	e4:SetCountLimit(1,20007)
	e4:SetOperation(scard.atkoperation)
	c:RegisterEffect(e4)
	--End Phase
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetTarget(scard.descon)
	e5:SetCountLimit(1,s_id-900000)
	e5:SetOperation(scard.desop)
	c:RegisterEffect(e5)
end
function scard.otfilter(c,tp)
	return c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER)
end
function scard.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(scard.otfilter,tp,LOCATION_HAND,0,e:GetHandler(),tp)
	return mg:GetCount()>=2
end
function scard.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(scard.otfilter,tp,LOCATION_HAND,LOCATION_HAND,e:GetHandler(),tp)
	local sg=Duel.SelectMatchingCard(tp,scard.otfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_SPSUMMON+REASON_MATERIAL)
	Duel.RegisterFlagEffect(tp,s_id,RESET_PHASE+PHASE_END,0,1)
end
function scard.filter(c,e,tp)
	return c:IsSetCard(0xded) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and scard.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,s_id)==1
		and Duel.IsExistingTarget(scard.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.ResetFlagEffect(tp,s_id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,scard.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SPSUMMON,g,1,0,0)
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function scard.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function scard.atkcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xded) and c:GetLevel()==7
end
function scard.atkfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0xded) and not c:IsImmuneToEffect(e)
end
function scard.atktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.atkcfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function scard.atkoperation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(scard.atkfilter,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(700)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	Duel.RegisterFlagEffect(tp,s_id+10000000,RESET_PHASE+PHASE_END,0,1)
end
function scard.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xded)
end
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,s_id+10000000)==1
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,LOCATION_MZONE,0,nil,e)
	local gain=g:GetCount()*1000
	if Duel.Destroy(g,REASON_EFFECT)>0 then
	Duel.Recover(tp,gain,REASON_EFFECT) end
end
