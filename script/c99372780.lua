--Mysterious Crab
function c99372780.initial_effect(c)
   if not c99372780.global_check then
      c99372780.global_check=true
        local ge2=Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_ADJUST)
        ge2:SetCountLimit(1)
        ge2:SetLabel(326)
        ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
        ge2:SetOperation(c99372780.chk)
        Duel.RegisterEffect(ge2,0)
    end
end
c99372780.pandemonium=true
c99372780.pandemonium_lscale=1 --x = Left Pandemonium Scale
c99372780.pandemonium_rscale=6 --y = Right Pandemonium Scale
function c99372780.chk(e,tp,eg,ep,ev,re,r,rp)
    Duel.CreateToken(tp,e:GetLabel())
    Duel.CreateToken(1-tp,e:GetLabel())
end

