--Moon Burst's Reaction
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69181753,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cid.spcon)
	e2:SetCost(cid.spcost)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()  end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cid.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666) and c:IsFaceup() and c:GetBaseAttack()<2001
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local a=Duel.GetAttacker()
		local ag=a:GetAttackableTarget()
		if a:IsAttackable() and not a:IsImmuneToEffect(e) and ag:IsContains(tc) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
			e1:SetValue(math.ceil(tc:GetBaseAttack()*1))
			tc:RegisterEffect(e1)
		end
	end
end
function cid.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)~=0 and e:GetHandler()==Duel.GetAttackTarget()
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cid.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(cid.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function cid.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end