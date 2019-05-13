--Artro-Sovrano, Pyrozanna
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
	--pendulum
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--inflict damage
	local p1=Effect.CreateEffect(c)
	p1:SetDescription(aux.Stringid(id,0))
	p1:SetCategory(CATEGORY_DAMAGE)
	p1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	p1:SetCode(EVENT_DESTROYED)
	p1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCountLimit(1)
	p1:SetCondition(cid.damcon)
	p1:SetTarget(cid.damtg)
	p1:SetOperation(cid.damop)
	c:RegisterEffect(p1)
	--selfdestroy + damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cid.drytg)
	e1:SetOperation(cid.dryop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,5))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cid.thcon)
	e2:SetTarget(cid.thtg)
	e2:SetOperation(cid.thop)
	c:RegisterEffect(e2)
end
--filters
function cid.thfilter(c)
	return c:IsSetCard(0x89f) and c:IsAbleToHand()
end
--inflict damage
function cid.damcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		local rc=des:GetReasonCard()
		return rc and rc:IsSetCard(0x89f) and rc:IsControler(tp) and rc:IsRelateToBattle()
	elseif re then
		local rc=re:GetHandler()
		return eg:IsExists(Card.IsReason,1,nil,REASON_EFFECT)
			and rc and rc:IsSetCard(0x89f) and rc:IsControler(tp) and re:IsActiveType(TYPE_MONSTER)
	end
	return false
end
function cid.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc
	if eg:GetCount()>1 then
		tc=eg:Select(tp,1,1,nil)
	else
		tc=eg:GetFirst()
	end
	local dam,atk,def=0,tc:GetAttack(),tc:GetDefense()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local sel=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if sel==0 then dam=atk else dam=def end
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--selfdestroy + damage
function cid.drytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,e:GetHandler(),TYPE_MONSTER)*200
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	if dam>0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
end
function cid.dryop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)*200
		if dam>0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
--search
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cid.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end