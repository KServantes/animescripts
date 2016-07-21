--Master Magician's Incantation
--  By Shad3
--Activation of Chaining Spells (My Body as a Shield) still needs work
--Works perfectly for "EVENT_FREE_CHAIN" spells only

local self=c511005060

function self.initial_effect(c)
  --Global check
  if not self['gl_chk'] then
    self['gl_chk']=true
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_CHAINING)
    ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    ge1:SetOperation(self.flag_op)
    Duel.RegisterEffect(ge1,0)
  end
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(self.tg)
  e1:SetOperation(self.op)
  c:RegisterEffect(e1)
end

function self.flag_op(e,tp,eg,ep,ev,re,r,rp)
  local ch=Duel.GetCurrentChain()
  self['cstore_'..ch]={eg,ep,ev,re,r,rp}
end

function self.hnd_fil(c,e,tp,eg,ep,ev,re,r,rp)
  if c:IsType(TYPE_SPELL) and c:GetOriginalCode()~=511005060 then
    local te=c:GetActivateEffect()
    if not te then return end
    local cd=te:GetCondition()
    local cs=te:GetCost()
    local tg=te:GetTarget()
    Debug.Message(te:GetCode())
    if te:GetCode()==EVENT_CHAINING then
      local ch=Duel.GetCurrentChain()-1
      Debug.Message(ch)
      if ch>0 then
        local i=self['cstore_'..ch]
        local neg,nep,nev,nre,nr,nrp=i[1],i[2],i[3],i[4],i[5]
        return (not cd or cd(te,tp,neg,nep,nev,nre,nr,nrp)) and
          (not cs or cs(te,tp,neg,nep,nev,nre,nr,nrp,0)) and
          (not tg or tg(te,tp,neg,nep,nev,nre,nr,nrp,0))
      end
    elseif te:GetCode()==EVENT_FREE_CHAIN then
      return (not cd or cd(te,tp,eg,ep,ev,re,r,rp)) and
        (not cs or cs(te,tp,eg,ep,ev,re,r,rp,0)) and
        (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0))
    end
  end
  return false
end

function self.szo_fil(c,e,tp,eg,ep,ev,re,r,rp)
  return not c:IsFaceup() and self.hnd_fil(c,e,tp,eg,ep,ev,re,r,rp)
end

function self.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local loc=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if e:GetHandler():IsLocation(LOCATION_HAND) then loc=loc-1 end
    if loc>1 then
      return Duel.IsExistingMatchingCard(self.szo_fil,tp,LOCATION_SZONE,0,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp) or Duel.IsExistingMatchingCard(self.hnd_fil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
    elseif loc==0 then
      return Duel.IsExistingMatchingCard(self.szo_fil,tp,LOCATION_SZONE,0,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
    end
    return false
  end
  e:SetProperty(0)
end

function self.op(e,tp,eg,ep,ev,re,r,rp)
  local og=Duel.GetMatchingGroup(self.szo_fil,tp,LOCATION_SZONE,0,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    og:Merge(Duel.GetMatchingGroup(self.hnd_fil,tp,LOCATION_HAND,0,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp))
  end
  local tc=og:Select(tp,1,1,nil):GetFirst()
  if not tc then return end
  local te=tc:GetActivateEffect()
  local cs=te:GetCost()
  local tg=te:GetTarget()
  local op=te:GetOperation()
  local neg,nep,nev,nre,nr,nrp=eg,ep,ev,re,r,rp
  if te:GetCode()==EVENT_CHAINING then
    local i=self['cstore_'..ch]
    neg,nep,nev,nre,nr,nrp=i[1],i[2],i[3],i[4],i[5]
  end
  Duel.ClearTargetCard()
  e:SetProperty(te:GetProperty())
  if tc:IsLocation(LOCATION_HAND) then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  else
    Duel.ChangePosition(tc,POS_FACEUP)
  end
  Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
  if not (tc:IsType(TYPE_SPELL) and tc:IsType(TYPE_CONTINUOUS)) then tc:CancelToGrave(false) end
  if not tc:IsType(TYPE_SPELL) then return end
  tc:CreateEffectRelation(te)
  if cs then cs(te,tp,neg,nep,nev,nre,nr,nrp,1) end
  if tg then tg(te,tp,neg,nep,nev,nre,nr,nrp,1) end
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if g then
    local tgc=g:GetFirst()
    while tgc do
      tgc:CreateEffectRelation(te)
      tgc=g:GetNext()
    end
  end
  tc:SetStatus(STATUS_ACTIVATED,true)
  if op then op(te,tp,neg,nep,nev,nre,nr,nrp) end
  tc:ReleaseEffectRelation(te)
  if g then
    local tgc=g:GetFirst()
    while tgc do
      tgc:ReleaseEffectRelation(te)
      tgc=g:GetNext()
    end
  end
end