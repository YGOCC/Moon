--created and scripted by rising phoenix
function c100001196.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_REMOVED)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	c:RegisterEffect(e1)
		--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetValue(c100001196.efilter)
	c:RegisterEffect(e4)
			--act
	local e10=Effect.CreateEffect(c)
	e10:SetOperation(c100001196.actb)
	e10:SetCost(c100001196.descost)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PREDRAW)
	e10:SetCondition(c100001196.condition1)
	e10:SetRange(LOCATION_DECK)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e10)
	--acthand
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e20:SetRange(LOCATION_HAND)
	e20:SetCode(EVENT_DRAW)
		e20:SetCondition(c100001196.condition1)
	e20:SetOperation(c100001196.actb)
	e20:SetCost(c100001196.descost)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e20)
	--actgrave
	local e30=Effect.CreateEffect(c)
	e30:SetOperation(c100001196.actb)
	e30:SetCost(c100001196.descost)
	e30:SetRange(LOCATION_GRAVE)
		e30:SetCondition(c100001196.condition1)
	e30:SetCode(EVENT_DRAW)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e30)
end
function c100001196.filter(c)
	return c:IsFaceup() and c:IsCode(100001155)
end
function c100001196.check()
	return Duel.IsExistingMatchingCard(c100001196.filter,0,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsEnvironment(100001155)
end
function c100001196.condition1(e,tp,eg,ep,ev,re,r,rp)
	return c100001196.check()
end
function c100001196.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c100001196.actb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c100001196.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100001196)==0 end
	Duel.RegisterFlagEffect(tp,100001196,0,0,0)
end
function c100001196.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100001196.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	end
