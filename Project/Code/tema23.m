function tema23 
clc
a=3;
L=10;
tmax=6;
x=0:L/100:L;
t=0:tmax/100:tmax;
for i=1:length(t)
    plot(x, fourier(x,t(i)),'r',0,0,'k*')
    axis([0,L,-5*pi,5*pi])
    grid on
    M(i)=getframe;
end
movie(M,5)
    function y=fourier(x,t)
    y=0;
    for k=1:35
        Xk=sin(k*pi*x/L);
        Tk=A(k)*cos(a*k*pi*t/L)+B(k)*sin(a*k*pi*t/L);
        y=y+Xk.*Tk;
    end
    end
    function y=A(k)
        Xk=sin(k*pi*x/L);
        y=2*trapz(x,phi(x).*Xk)/L;
    end
    function y=B(k)
         Xk=sin(k*pi*x/L);
        y=2*trapz(x,psi(x).*Xk)/(a*k*pi);
    end
    function y=phi(x)
      for j=1:length(x)
           if 2*pi <= x(j) && x(j)<= 3*pi
                y(j)=((x(j)-2*pi)^3)*((x(j)-3*pi)^4);
        elseif (0<=x(j) && x(j)<2*pi)||(3*pi<x(j) && x(j)<=L)
            y(j)=0;
            end
        end
    end
    function y=psi(x)
    y=0;
     end
end

