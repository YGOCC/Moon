--D.D. Graviton Dragon
function c32083042.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c32083042.splimit)
	c:RegisterEffect(e1)
			--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32083042,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c32083042.target)
	e2:SetOperation(c32083042.operation)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_REMOVED)
	e3:SetTarget(c32083042.distg)
	c:RegisterEffect(e3)
		--cannot trigger
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_REMOVED)
	e4:SetTarget(c32083042.distg)
	c:RegisterEffect(e4)
end
function c32083042.distg(e,c)
	return c:IsType(TYPE_TRAP) or c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL)
end
function c32083042.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsSetCard(0x7D53)
end
function c32083042.desfilter(c)
	return c:IsAbleToRemove()
end
function c32083042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,C,g,g:GetCount(),0,0)
	e:SetLabel(dis)
end
function c32083042.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetLabel(seq)
		e1:SetOperation(c32083042.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c32083042.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end