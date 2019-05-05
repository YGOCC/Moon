--Number U300: CREATION-Eyes Dimensional Evolution Dragon
local card = c88880055
local m=88880055
local cm=_G["c"..m]
function Card.initial_effect(c)
	c:EnableReviveLimit()
	--(0)Reality Summon (Required for a Reality monster)
	xpcall(function() require("expansions/script/c88880062") end,function() require("script/c88880062") end)
	Reality.AddRealityProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),Card.rcheck,5,5)
	--(1) This cards Reality Cycle is increased by the original rank of the "CREATION-Eyes" Xyz monster that was used for this cards Reality Summon.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(Card.addtg)
	e1:SetOperation(Card.addop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(Card.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--(2) Once per turn, if this card would be involved in battle (Quick Effect): you can destroy every card in the Pendulum Scale, then, destroy 2 "CREATION" Pendulum monsters in your hand; Increase this cards ATK by 100 for each scale of the destroyed cards.
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetTarget(Card.atktg)
	e3:SetOperation(Card.atkop)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--(3) When this cards reality cycle equals 0: increase your LP by this cards current ATK.
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(Card.recon)
	e4:SetOperation(Card.reop)
	c:RegisterEffect(e4)
end
--(0) Reality Summon
function Card.refilter(c,realityc)
	return (c:IsSetCard(0x889) and c:IsType(TYPE_MONSTER))
end
function Card.rcheck(g)
	return (g:IsExists(Card.IsType,1,nil,TYPE_XYZ) and g:IsExists(Card.IsSetCard,1,nil,0x1889))
end
--(1) This cards Reality Cycle is increased by the original rank of the "CREATION-Eyes" Xyz monster that was used for this cards Reality Summon.
function Card.addfilter(c)
	return c:IsSetCard(0x1889) and c:IsType(TYPE_XYZ)
end
function Card.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,88880010) or g:IsExists(Card.IsCode,1,nil,88881010) then
		e:GetLabelObject():SetLabel(4)
	elseif g:IsExists(Card.IsCode,1,nil,88880011) or g:IsExists(Card.IsCode,1,nil,88881011) then
		e:GetLabelObject():SetLabel(5)
	elseif g:IsExists(Card.IsCode,1,nil,88880012) or g:IsExists(Card.IsCode,1,nil,88881012) then
		e:GetLabelObject():SetLabel(6)
	elseif g:IsExists(Card.IsCode,1,nil,88880013) or g:IsExists(Card.IsCode,1,nil,88881013) then
		e:GetLabelObject():SetLabel(7)
	elseif g:IsExists(Card.IsCode,1,nil,88880014) or g:IsExists(Card.IsCode,1,nil,88881014) then
		e:GetLabelObject():SetLabel(8)
	elseif g:IsExists(Card.IsCode,1,nil,88880015) or g:IsExists(Card.IsCode,1,nil,88881015) or g:IsExists(Card.IsCode,1,nil,88880016) then
		e:GetLabelObject():SetLabel(9)
	--elseif g:IsExists(Card.IsCode,1,nil,88880011) or g:IsExists(Card.IsCode,1,nil,88881011) then
		--e:GetLabelObject():SetLabel(10)
	--elseif g:IsExists(Card.IsCode,1,nil,88880011) or g:IsExists(Card.IsCode,1,nil,88881011) then
		--e:GetLabelObject():SetLabel(11)
	elseif g:IsExists(Card.IsCode,1,nil,88880022) then
		e:GetLabelObject():SetLabel(12)
	elseif g:IsExists(Card.IsCode,1,nil,88880056) then
		e:GetLabelObject():SetLabel(13)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function Card.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+0x903)
end
function Card.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0x77)
end
function Card.addop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x77,e:GetLabel())
	end
end
--(2) Once per turn, if this card would be involved in battle (Quick Effect): you can destroy every card in the Pendulum Scale, then, destroy 2 "CREATION" Pendulum monsters in your hand; Increase this cards ATK by 100 for each scale of the destroyed cards.
function Card.filter1(c,e,tp)
	return c:IsSetCard(0x889) and c:IsType(TYPE_PENDULUM)
end
function Card.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.filter1,tp,LOCATION_HAND,0,2,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function Card.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	Duel.Destroy(sg,REASON_COST)
	local sg2=Duel.SelectMatchingCard(tp,Card.filter1,tp,LOCATION_HAND,0,2,2,nil)
	Duel.Destroy(sg2,REASON_COST)
	sg:Merge(sg2)
	local c=e:GetHandler()
	local tc=sg:GetSum(Card.GetLeftScale)*100
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=tc
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
--(3) When this cards reality cycle equals 0: increase your LP by this cards current ATK.
function Card.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetCounter(0x77)==0
end
function Card.reop(e,tp,eg,ep,ev,re,r,rp)
	--if e:GetHandler():GetCounter(0x77)==1 then
		local atk=e:GetHandler():GetPreviousAttackOnField()
		Duel.Recover(tp,atk,REASON_EFFECT)
	--end
end