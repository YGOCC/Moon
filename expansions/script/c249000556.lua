--Transcendental Senshi
function c249000556.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetOperation(c249000556.caop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98558751,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c249000556.drcon)
	e2:SetTarget(c249000556.drtg)
	e2:SetOperation(c249000556.drop)
	c:RegisterEffect(e2)	
	--change target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1498130,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c249000556.tgcon)
	e3:SetOperation(c249000556.tgop)
	c:RegisterEffect(e3)
end
function c249000556.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if Duel.GetAttacker()==c and bc and c:IsRelateToBattle() and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
function c249000556.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c249000556.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000556.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c249000556.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc==c or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsLocation(LOCATION_MZONE) then return false end
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c249000556.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Group.CreateGroup()
		g:AddCard(c)
		Duel.ChangeTargetCard(ev,g)
	end
end