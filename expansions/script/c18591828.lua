--ASSASSIN - ROSE
function c18591828.initial_effect(c)
    --tribute check
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(c18591828.valcheck)
    c:RegisterEffect(e1)
    --give atk effect only when  summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SUMMON_COST)
    e2:SetOperation(c18591828.facechk)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --to defense
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(18591828,0))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e3:SetTarget(c18591828.postg)
    e3:SetOperation(c18591828.posop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DEFENSE_ATTACK)
    c:RegisterEffect(e4)
end
function c18591828.valcheck(e,c)
    local tc=c:GetMaterial():GetFirst()
    local atk=0
    if tc then atk=tc:GetTextAttack()*2 end
    if atk<0 then atk=0 end
    if e:GetLabel()==1 then
        e:SetLabel(0)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1)
    end
end
function c18591828.facechk(e,tp,eg,ep,ev,re,r,rp)
    e:GetLabelObject():SetLabel(1)
end
function c18591828.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
