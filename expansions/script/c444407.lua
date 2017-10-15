-- Modular Backup
function c444407.initial_effect(c)
    -- custom copying of backup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444407,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c444407.condition)
	e1:SetCost(c444407.cost)
	e1:SetTarget(c444407.target)
	e1:SetOperation(c444407.operation)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCondition(c444407.passivescondition)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--30459350 chk (no clue what it does, really)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCondition(c444407.passivescondition)
	e3:SetCode(444407)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444407.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2  and aux.exccon(e)
end
function c444407.passivescondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  not eqc 
end
-- copy target 
function c444407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chkc then return chkc:IsControler(tp) and c444407.copyfilter(chkc) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
	if chk==0 then return Duel.IsExistingMatchingCard(c444407.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	else
	if chk==0 then return Duel.IsExistingMatchingCard(c444407.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	Duel.SelectTarget(tp,c444407.copyfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444407.copyfilter(c)
	return c:IsSetCard(4444)
end
--copy operation
function c444407.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()   
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
    if tc and tc:IsRelateToEffect(e)  and c:IsFaceup() then --   and c:IsRelateToEffect(e) and not tc:IsType(TYPE_TOKEN)
       local code=tc:GetOriginalCodeRule()
       local cid=0
        if Duel.GetTurnPlayer()==tp then    
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY,2)
        else        
            cid=c:CopyEffect(code,RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        end
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(444407,1))
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCountLimit(1)
        e2:SetRange(LOCATION_ONFIELD)
        if Duel.GetTurnPlayer()==tp then
            e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
        else
            e2:SetReset(RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        end
        e2:SetLabel(cid)
        e2:SetOperation(c444407.rstop)
        c:RegisterEffect(e2)
    end
end
function c444407.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c444407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
	if chk==0 then return Duel.IsExistingMatchingCard(c444407.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c444407.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	else
	if chk==0 then return Duel.IsExistingMatchingCard(c444407.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c444407.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	end
end

function c444407.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(4444)
end  