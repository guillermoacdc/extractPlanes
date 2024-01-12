
meandcomean=mean(dco_mean);
meandcomax=mean(dco_maxn);
meandcomin=mean(dco_min);
figure,
subplot(311),...
    stem(keyframes(1:239),dco_mean,"filled")
    xlabel 'keyframes'
    ylabel (['dco_{mean}=' num2str(meandcomean)])
    grid
title (['distance camera object in session ' num2str(sessionID)])      
subplot(312),...
    stem(keyframes(1:239),dco_maxn,"filled")
    xlabel 'keyframes'
    ylabel (['dco_{max}=' num2str(meandcomax)])
    grid    
subplot(313),...
    stem(keyframes(1:239),dco_min,"filled")
    xlabel 'keyframes'
    ylabel (['dco_{min}=' num2str(meandcomin)])
    grid      

  