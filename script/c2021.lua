--Mystic Forest of the Winds
function c2021.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--anti banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c2021.banishlimit)
	c:RegisterEffect(e2)
--Draw
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2021,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c2021.dcon)
	e3:SetTarget(c2021.dtg)
	e3:SetOperation(c2021.dop)
	c:RegisterEffect(e3)
--honesting lel
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2021,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c2021.atkcon)
	e1:SetOperation(c2021.atkop)
	c:RegisterEffect(e1)
end
function c2021.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	return a:IsFaceup() and a:IsRelateToBattle() and a:IsSetCard(0x202) and not a:IsType(TYPE_SYNCHRO)
		and d and d:IsFaceup() and d:IsRelateToBattle()
		and (d:GetAttack()>0 or a:GetAttack()>0) and a:GetControler()~=d:GetControler()
end
function c2021.atkop(e,tp,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	local b,atk=nil,0
	if a:IsControler(tp) then b,atk=a,d:GetAttack()
	else b,atk=d,a:GetAttack() end
	if e:GetHandler():IsRelateToEffect(e) and b
		and a:IsFaceup() and a:IsRelateToBattle()
		and d:IsFaceup() and d:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		b:RegisterEffect(e1)
	end
end
function c2021.dfilter(c,tp)
	return c:IsSetCard(0x202) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_DECK) --and bit.band(c:GetReason(),0x40)==0x40
end
function c2021.dcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c2021.dfilter,1,nil,tp) and re:GetOwner():IsSetCard(0x202)
end
function c2021.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c2021.dop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c2021.banishlimit(e,c)
	return c:IsSetCard(0x202)
end