--Protector Statue of the Heavens
local ref=_G['c'..18917033]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1,326)
		ge2:SetLabel(326)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
	
	--ACtivate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18917033,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE+LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(ref.actcon)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	--On Normal
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(ref.nstg)
	e2:SetOperation(ref.nsop)
	c:RegisterEffect(e2)
	--Re-Set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(ref.setcon)
	e3:SetCost(ref.setcost)
	e3:SetTarget(ref.settg)
	e3:SetOperation(ref.setop)
	c:RegisterEffect(e3)
end

ref.pandemonium=true
ref.pandemonium_lscale=6
ref.pandemonium_rscale=2
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,326)
	Duel.CreateToken(1-tp,326)
end

--Pandemonium effect
function ref.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and eg:GetFirst():IsControler(1-tp)
end
function ref.actfilter(c)
	return c:IsAttackPos() and c:IsAbleToRemove()
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local trigc=eg:GetFirst()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc~=trigc and ref.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.actfilter,tp,0,LOCATION_MZONE,1,trigc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,ref.actfilter,tp,0,LOCATION_MZONE,1,1,trigc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) and Duel.Remove(tc,nil,REASON_EFFECT)==1 then
		Duel.Recover(tp,1000,REASON_EFFECT)
		Duel.Recover(1-tp,1000,REASON_EFFECT)
	end
end
function ref.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end

--On Normal Summon effects
function ref.nsfilter(c)
	return c.pandemonium and not c:IsForbidden()
end
function ref.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.nsfilter,tp,LOCATION_DECK,0,1,nil) end
end
function ref.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,ref.nsfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end

--Reset to your side of the field
function ref.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and aux.exccon(e)
end
function ref.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_LIGHT)
	Duel.Release(g,REASON_COST)
end
function ref.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function ref.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
