--CARD NAME
local card = c2158563
function card.initial_effect(c)
	--ss
e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,2158563)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c2158563.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2158563,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,2158563+200)
	e2:SetTarget(c2158563.destg2)
	e2:SetOperation(c2158563.desop2)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCountLimit(1,2158563+300)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c2158563.atkcon)
	e3:SetValue(c2158563.atkval)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c2158563.atlimit)
	c:RegisterEffect(e4)
	--triute and atk & def down
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2158563,0))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,2158563+100)
	e5:SetTarget(c2158563.atktg)
	e5:SetOperation(c2158563.atkop)
	c:RegisterEffect(e5)
	--to grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(2158563,0))
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_TO_GRAVE+EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetCountLimit(1,2158563+500)
	e6:SetOperation(cm.gyoper)
	c:RegisterEffect(e6)
  -- burn
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(2158563,0))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetCountLimit(1,2158563+600)
	e7:SetCost(cm.gycost)
	e7:SetTarget(cm.gytg)
	e7:SetOperation(cm.gyop)
	c:RegisterEffect(e7)
	--idestructable E
	local e2=Effect.CreateEffect(c)
   e8:SetType(EFFECT_TYPE_SINGLE)
   e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
   e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
   e8:SetRange(LOCATION_MZONE)
   e8:SetValue(c2158563.indval)
   c:RegisterEffect(e8)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--damage
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(2158563,0))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetRange(LOCATION_PZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c2158563.damcon)
	e9:SetTarget(c2158563.damtg)
	e9:SetOperation(c2158563.damop)
	c:RegisterEffect(e9)
	--atk
function c2158563.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x999)
end
function c2158563.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c2158563.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c2158563.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c2158563.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	end
	function c2158563.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function c2158563.atkval(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local atk=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)*200
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	end
	function c2158563.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x999) and c~=e:GetHandler()
	end
	function c2158563.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Release(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc2=g:GetFirst()
		while tc2 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(tc2:GetAttack()/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(math.ceil(tc2:GetDefense()/2))
			tc2:RegisterEffect(e2)
			tc2=g:GetNext()
		end
	end
end
function c2158563.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	function cm.gyoper(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
end
function cm.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp, e:GetHandler())  end
	Duel.SendtoDeck(e:GetHandler(),nil,REASON_EFFECT)
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c2158563.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
				Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function c2158563.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c2158563.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x999) and rc:IsControler(tp)
end
function c2158563.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c2158563.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end