--Oscurità Irregolare - Pugno Terrificante
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,2,cid.ovfilter,aux.Stringid(id,0),3,cid.xyzop)
	c:EnableReviveLimit()
	--boost atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cid.atkcon)
	e1:SetTarget(cid.atktg)
	e1:SetOperation(cid.atkop)
	c:RegisterEffect(e1)
end
--filters
function cid.ovfilter(c)
	return c:IsFaceup() and c:IsRank(4) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x4999)
end
function cid.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
--boost atk
function cid.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():IsControler(1-tp)
end
function cid.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
	local td=Duel.GetDecktopGroup(tp,1)
	Duel.Overlay(e:GetHandler(),td)
	if e:GetHandler():GetOverlayGroup():IsContains(td:GetFirst()) then
		Duel.BreakEffect()
		local atk=0
		if td:GetFirst():IsType(TYPE_MONSTER) then
			atk=1000
		elseif td:GetFirst():IsType(TYPE_SPELL+TYPE_TRAP) then
			atk=500
		else
			return
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end