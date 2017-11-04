--Starbreaker
function c18917001.initial_effect(c)
    --Activate
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_ACTIVATE)
	se1:SetDescription(aux.Stringid(18917001,0))
	se1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(se1)
	--Psummon
	local se2=Effect.CreateEffect(c)
	se2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	se2:SetCode(EVENT_ADJUST)
	se2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	se2:SetRange(LOCATION_PZONE)
	se2:SetTargetRange(0,LOCATION_PZONE)
	se2:SetOperation(c18917001.psactivate)
	c:RegisterEffect(se2)
	--opponent splimit
	local se3=Effect.CreateEffect(c)
	se3:SetType(EFFECT_TYPE_FIELD)
	se3:SetRange(LOCATION_PZONE)
	se3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	se3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	se3:SetTargetRange(0,1)
	se3:SetCondition(c18917001.psopcon)
	se3:SetTarget(c18917001.psoplimit)
	c:RegisterEffect(se3)
	--Self Destroy
	local se4=Effect.CreateEffect(c)
	se4:SetType(EFFECT_TYPE_IGNITION)
	se4:SetRange(LOCATION_PZONE)
	se4:SetCategory(CATEGORY_DESTROY)
	se4:SetDescription(aux.Stringid(18917001,1))
	se4:SetOperation(c18917001.selfDes)
	c:RegisterEffect(se4)
	
	--Revive
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18917001,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c18917001.sscon)
	e1:SetTarget(c18917001.sstg)
	e1:SetOperation(c18917001.ssop)
	c:RegisterEffect(e1)
	--Anti-Spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c18917001.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c18917001.aclimset)
	c:RegisterEffect(e3)
	--Tuner
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18917001,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c18917001.tunetg)
	e4:SetOperation(c18917001.tuneop)
	c:RegisterEffect(e4)
end

function c18917001.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb00) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function c18917001.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18917001.cfilter,1,nil,tp)
end
function c18917001.ssfilter2(c,code)
	return c:IsCode(code)
end
function c18917001.ssfilter(c,e,tp,g)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
		and g:IsExists(c18917001.ssfilter2,1,nil,c:GetCode())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18917001.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=eg:Filter(c18917001.cfilter,nil,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18917001.ssfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c18917001.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=eg:Filter(c18917001.cfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18917001.ssfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,sg)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end

function c18917001.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) or (bit.band(c:GetType(),0x2)~=0x2) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:GetFlagEffect(18917001)>0
end
function c18917001.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterEffect(18917001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		tc=eg:GetNext()
	end
end

function c18917001.tunefilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c18917001.tunetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c18917001.tunefilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c18917001.tunefilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c18917001.tunefilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c18917001.tuneop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetRange(LOCATION_MZONE)
		tc:RegisterEffect(e1)
	end
end

--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c18917001.psopcon(e,c)
	local tp=e:GetHandler()
	local lscale=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rscale=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return lscale and rscale and lscale:IsSetCard(0xb00) and rscale:IsSetCard(0xb00)
end
function c18917001.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end

function c18917001.psactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	--Note: Do not change the number for the flag effect.
	if tc1 and tc1:GetFlagEffect(77777831)<1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c18917001.pendcon)
	e1:SetOperation(c18917001.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(77777831,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c18917001.spfilter(c)
return c:IsFaceup() and c:IsSetCard(0xb00)
end
function c18917001.pendcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	--If either scale is a reverse pendulum, then you cannot pendulum summon
	if c:IsSetCard(0xb00) or rpz:IsSetCard(0xb00) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
	return og:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale)
	and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
	else
	return Duel.IsExistingMatchingCard(aux.PConditionFilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp,lscale,rscale)
	and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
	end
end
function c18917001.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=og:FilterSelect(tp,aux.PConditionFilter,1,ft,nil,e,tp,lscale,rscale)
	sg:Merge(g)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.PConditionFilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,ft,nil,e,tp,lscale,rscale)
	sg:Merge(g)
	end
end 

function c18917001.selfDes(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end