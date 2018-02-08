--created & coded by Lyris
--機光襲雷竜－ニューン
function c240100027.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x7c4),c240100027.ffilter,1,5,true)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c240100027.descon)
	e2:SetOperation(c240100027.desop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,240100038)
	e4:SetTarget(c240100027.sptg)
	e4:SetOperation(c240100027.spop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c240100027.matcheck)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
end
function c240100027.ffilter(c,fc,sub,mg,sg)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON)
end
function c240100027.matcheck(e,c)
	local ct=e:GetHandler():GetMaterialCount()-2
	e:GetLabelObject():SetLabel(ct)
end
function c240100027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,ct)
	local ds=Duel.GetDecktopGroup(tp,math.ceil(ct/2))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ds,ds:GetCount(),tp,LOCATION_DECK)
end
function c240100027.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then return end
	local d1=Duel.Draw(tp,ct,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,ct,REASON_EFFECT)
	local g=Duel.GetDecktopGroup(tp,math.ceil(ct/2))
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.DisableShuffleCheck()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c240100027.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100027.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
