--Moon's Dream: Escape!
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
 	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.dodgetg)
	e1:SetOperation(cid.dodgeop)
	c:RegisterEffect(e1)
end
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToRemove()
end
function cid.costfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cid.filter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cid.dodgetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end	
function cid.dodgeop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local ph=Duel.GetCurrentPhase()
    if ph==PHASE_DRAW then
        ph=PHASE_STANDBY
    elseif ph==PHASE_STANDBY then
        ph=PHASE_MAIN1
    elseif ph==PHASE_MAIN1 then
    ph=PHASE_BATTLE_START
    elseif ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
        ph=PHASE_MAIN2
    else
        ph=PHASE_END
    end
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EVENT_PHASE+ph)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
     --   e1:SetReset(RESET_PHASE+(ph)+RESET_EVENT+0x1fc0000)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetOperation(cid.retop)
        Duel.RegisterEffect(e1,tp)
		if	Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE) 
			Duel.Remove(frag,POS_FACEUP,REASON_EFFECT) 
	end
		if frag and not Duel.RemoveCards then 
		Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
		Duel.Remove(frag,POS_FACEUP,REASON_EFFECT) 
	end
		Card.CancelToGrave(c)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		end
	end
end

function cid.retop(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject())
end