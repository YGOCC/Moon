-- Modular Replica 
function c444420.initial_effect(c)
	--special/activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444420,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCost(c444420.cost)
	e1:SetCondition(c444420.returncondition)
	e1:SetOperation(c444420.ctlop)
	c:RegisterEffect(e1)
	-- activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(444420,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c444420.condition)
	e3:SetTarget(c444420.target)
	e3:SetOperation(c444420.operation)
	c:RegisterEffect(e3)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444420.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and not eqc 
end
-- copy functions: target
function c444420.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c444420.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c444420.copyfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c444420.copyfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())	
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444420.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(4444)
end
-- copy functions: operation
function c444420.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
        local code=tc:GetOriginalCodeRule()
        local cid=0
        if not tc:IsType(TYPE_TRAPMONSTER) then
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(444420,1))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCountLimit(1)
        e2:SetRange(LOCATION_ONFIELD)
        e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        e2:SetLabel(cid)
        e2:SetOperation(c444420.rstop)
        c:RegisterEffect(e2)
    end
end
-- copy functions: reset
function c444420.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
    c:ResetEffect(cid,RESET_CARD)
end

function c444420.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c444420.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()

    if e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c444420.mfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) then
		local g1=Duel.GetMatchingGroup(c444420.mfilter,tp,LOCATION_GRAVE,0,nil,e)
		local tp=e:GetHandler():GetControler()		
		local sg1=g1:Select(tp,1,1,e:GetHandler())		
		local tc=sg1:GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end

	if (e:GetHandler():IsType(TYPE_TRAP) or e:GetHandler():IsType(TYPE_SPELL)) and not e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c444420.stfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) then
		local g1=Duel.GetMatchingGroup(c444420.stfilter,tp,LOCATION_GRAVE,0,nil,e)
		local tp=e:GetHandler():GetControler()		
		local sg1=g1:Select(tp,1,1,e:GetHandler())		
		local tc=sg1:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end

    Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end

function c444420.stfilter(c,e,tp)
	if e:GetHandler():IsType(TYPE_SPELL) then
		return c:IsType(TYPE_SPELL) and c:GetActivateEffect():IsActivatable(tp)
	end
	if e:GetHandler():IsType(TYPE_TRAP) then
		return c:IsType(TYPE_TRAP) and c:GetActivateEffect():IsActivatable(tp)
	end
end

function c444420.mfilter(c,e,tp)
	if e:GetHandler():IsType(TYPE_MONSTER) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) 
	end
end

function c444420.returncondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	if (e:GetHandler():IsType(TYPE_TRAP) or e:GetHandler():IsType(TYPE_SPELL)) and not e:GetHandler():IsType(TYPE_MONSTER)  then
		return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and Duel.IsExistingMatchingCard(c444420.stfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) and not eqc 
    end
    if e:GetHandler():IsType(TYPE_MONSTER) then
    	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 and Duel.IsExistingMatchingCard(c444420.mfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) and not eqc 
    end
end