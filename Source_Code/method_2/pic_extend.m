function [ Eximg1 ] = pic_extend( I1,k)  

[L1,W1]=size(I1);  
Eximg1=zeros(L1+2*k+1,W1+2*k+1);  
Eximg1(k+1:k+L1,k+1:k+W1)=I1;  
  
Eximg1(1:k,k+1:W1+k)=Eximg1(1:k,1:W1);                  
Eximg1(1:L1+k,W1+k+1:W1+2*k+1)=Eximg1(1:L1+k,W1:W1+k);    %extend right  
Eximg1(L1+k+1:L1+2*k+1,k+1:W1+2*k+1)=Eximg1(L1:L1+k,k+1:W1+2*k+1);    %extend down  
Eximg1(1:L1+2*k+1,1:k)=Eximg1(1:L1+2*k+1,k+1:2*k);       %extend left  
end  