--Generic Reverse Pendulum
function c18917003.initial_effect(c)
    --Activate
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_ACTIVATE)
	se1:SetDescription(aux.Stringid(18917003,0))
	se1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(se1)
	--Psummon
	local se2=Effect.CreateEffect(c)
	se2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	se2:SetCode(EVENT_ADJUST)
	se2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	se2:SetRange(LOCATION_PZONE)
	se2:SetTargetRange(0,LOCATION_PZONE)
	se2:SetOperation(c18917003.psactivate)
	c:RegisterEffect(se2)
	--opponent splimit
	local se3=Effect.CreateEffect(c)
	se3:SetType(EFFECT_TYPE_FIELD)
	se3:SetRange(LOCATION_PZONE)
	se3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	se3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	se3:SetTargetRange(0,1)
	se3:SetCondition(c18917003.psopcon)
	se3:SetTarget(c18917003.psoplimit)
	c:RegisterEffect(se3)
	--Self Destroy
	local se4=Effect.CreateEffect(c)
	se4:SetType(EFFECT_TYPE_IGNITION)
	se4:SetRange(LOCATION_PZONE)
	se4:SetCategory(CATEGORY_DESTROY)
	se4:SetDescription(aux.Stringid(18917003,1))
	se4:SetOperation(c18917003.selfDes)
	c:RegisterEffect(se4)
	
	--Anti-Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c18917003.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18917003,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,18917003+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c18917003.thcon)
	e2:SetTarget(c18917003.thtg)
	e2:SetOperation(c18917003.thop)
	c:RegisterEffect(e2)
	
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c18917003.cspcon)
	e3:SetOperation(c18917003.cspop)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c18917003.antg)
	c:RegisterEffect(e4)
	--Search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(18917003,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,18917003)
	e5:SetTarget(c18917003.thtg2)
	e5:SetOperation(c18917003.thop2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
end

function c18917003.indestg(e,tp,eg,ep,ev,re,r,rp)
	return c:GetLevel()>=5
end

function c18917003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c18917003.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xb00) and c:IsDefenceBelow(1500) and c:IsAbleToHand()
end
function c18917003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c18917003.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18917003.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18917003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c18917003.cfilter(c)
	return c:IsSetCard(0x99) and c:IsType(TYPE_MONSTER) and c:GetLevel()==7 and c:IsAbleToRemoveAsCost()
end
function c18917003.cspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18917003.cfilter,c:GetControler(),LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
end
function c18917003.cspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18917003.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c18917003.antg(e,c)
	return c~=e:GetHandler()
end

function c18917003.thfilter2(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c18917003.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18917003.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18917003.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18917003.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c18917003.psopcon(e,c)
	local tp=e:GetHandler()
	local lscale=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rscale=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return lscale and rscale and lscale:IsSetCard(0xb00) and rscale:IsSetCard(0xb00)
end
function c18917003.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end

function c18917003.psactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	--Note: Do not change the number for the flag effect.
	if tc1 and tc1:GetFlagEffect(77777831)<1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c18917003.pendcon)
	e1:SetOperation(c18917003.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(77777831,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c18917003.spfilter(c)
return c:IsFaceup() and c:IsSetCard(0xb00)
end
function c18917003.pendcon(e,c,og)
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
function c18917003.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
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

function c18917003.selfDes(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end