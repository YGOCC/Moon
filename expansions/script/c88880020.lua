--Creation Universe
function c88880020.initial_effect(c)
	--(1) You can only activate this card if you control a "CREATION" Xyz monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c88880020.atvcon)
	c:RegisterEffect(e1)
	--(2) All "CREATION" Xyz monsters gain 1000 ATK/DEF points.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c88880020.indtg)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--(3) Once per turn, when an attack is declared involving your "CREATION" Xyz monster: Place up to 2 "CREATION" Pendulum monsteres from your deck or extra deck into the Pendulum Zone, but destroy them at the end of the turn.
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88880020,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c88880020.pencon)
	e4:SetTarget(c88880020.pentg)
	e4:SetOperation(c88880020.penop)
	c:RegisterEffect(e4)
end
--(1) You can only activate this card if you control a "CREATION" Xyz monster.
function c88880020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x889) and c:IsType(TYPE_XYZ)
end
function c88880020.atvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88880020.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--(2) All "CREATION" Xyz monsters gain 1000 ATK/DEF points.
function c88880020.indtg(e,c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_XYZ) and not c:IsSetCard(0x903)
end
--(3) Once per turn, when an attack is declared involving your "CREATION" Xyz monster: Place up to 2 "CREATION" Pendulum monsteres from your deck or extra deck into the Pendulum Zone, but destroy them at the end of the turn.
function c88880020.pencon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return (a:IsControler(tp) and a:IsSetCard(0x889) and a:IsType(TYPE_XYZ) and a:IsFaceup())
		or (at and at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0x889) and at:IsType(TYPE_XYZ))
end
function c88880020.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x889) and ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or c:IsLocation(LOCATION_DECK))
end
function c88880020.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c88880020.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c88880020.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88880020,2))
	local g=Duel.SelectMatchingCard(tp,c88880020.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,2,nil)
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
			if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			tc=g:GetNext()
		end
	end
end