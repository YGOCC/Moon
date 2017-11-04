--Daedalus EX
local ref=_G['c'..18917026]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
	
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(ref.sscon)
	e1:SetTarget(ref.sstg)
	e1:SetOperation(ref.ssop)
	c:RegisterEffect(e1)
	--ATK down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(ref.atkcon)
	e2:SetTarget(ref.atktg)
	e2:SetOperation(ref.atkop)
	c:RegisterEffect(e2)
end

ref.bloom = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end
function ref.material(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end

function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+269
end
function ref.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsDestructable()
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and ref.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.exfilter(c)
	return c:IsType(TYPE_FIELD)
end
function ref.rmfilter(c)
	return true
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		if g:IsExists(ref.exfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(18917026,0)) then
			local g2=Duel.SelectMatchingCard(tp,ref.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
				Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end

function ref.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+269
		and e:GetHandler():GetMaterial():GetCount()>0
end
function ref.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local lv=0
	local tc=mg:GetFirst()
	while tc do
		lv = lv+tc:GetLevel()
		tc=mg:GetNext()
	end
	if chk==0 then return lv>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	end
	e:SetLabel(lv)
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
