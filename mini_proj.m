clc;
clear all;
close all;

% im=imread('cameraman.tif');
im=[0 1 0 1 0 1 0 1;
   1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1;
    1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1;
    1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1;
    1 0 1 0 1 0 1 0];
    
[p q]=size(im);
arry=[];
for i=1:p
    a=im(i,:);
    unq=uniq(a);
    for k=1:length(unq)
        cnt=0;
        for l=1:length(a)
            if a(l)==unq(k)
                cnt=cnt+1;
            end
        end
        pr{k}=cnt;
        arry=cat(2,arry,unq(k));
        arry=cat(2,arry,pr{k});
    end
end

binstr='';
num=ceil(log2(max(arry)+1));
for i=1:length(arry)
    b=dec2bin(arry(i),num);
    binstr=strcat(binstr,b);
end

cnt=0;
cn=0;
run=[];
p=0;
for i=1:length(binstr)
    if binstr(i)=='0'
        cnt=cnt+1;
        p=p+1;
        if cn~=0
            for j=1:cn
                run=cat(2,run,0);
            end
            cn=0;
        end
    else
        if cnt~=0
            run=cat(2,run,cnt);
            cnt=0;
        end
        if binstr(i-1)=='0'
            i=i+1;
        else
            if i>length(binstr)
                break;
            else
                if binstr(i)=='1'
                    cn=cn+1;
                end
            end
        end
    end
end
if cn~=0
    for j=1:cn
        run=cat(2,run,0);
    end
    cn=0;
end
if cnt~=0
    run=cat(2,run,cnt);
    cnt=0;
end

p=p/length(binstr);
m=ceil(-(1/log2(p)));
N=max(run);
cl=ceil(log2(m));
fl=floor(log2(m));
for i=1:N+1
    n(i)=i-1;
    q(i)=floor(n(i)/m);
    r(i)=n(i)-q(i)*m;
    qcode='';
    if q(i)==0
        qcode='0';
    else for j=1:q(i)
            qcode=strcat(qcode,'1');
        end
        qcode=strcat(qcode,'0');
    end
    if r(i)<=fl
        rcode=dec2bin(r(i),fl);
    else rcode=dec2bin((r(i)+(2^cl)-m),cl);
    end
    code{i}={i-1 strcat(qcode,rcode)};
end
enc='';
for i=1:length(run)
    for j=1:length(code)
    c=code{j};
    if c{1}==run(i)
        break;
    end
    end
    enc=strcat(enc,c{2});
end

%DECODING
runn=[];
y=code{N+1};
z=length(y{2});
k=1;
while k<=length(enc)
    for j=1:length(code)
        c=code{j};
        l=length(c{2});
        if (k+l-1)<=length(enc)
            if strcmp(enc(k:(k+l-1)),c(2))==1
                st=c{1};
                l1=l;
            end
        end
    end
        runn=cat(2,runn,st);
        k=k+l1;
    end
    
    binstr1='';
    for i=1:length(runn)
        if runn(i)==0
            binstr1=strcat(binstr1,'1');
        else for j=1:runn(i)
                binstr1=strcat(binstr1,'0');
            end
            if i~=length(runn)
                binstr1=strcat(binstr1,'1');
            end
        end
    end
    
    array=[];
    k=1;
    while k<=length(binstr1)
        b=bin2dec(binstr1(k:(k+num-1)));
        array=cat(2,array,b);
        k=k+num;
    end
    
    [p q]=size(im);
    k=1;
    for i=1:p
        for j=1:q
            if mod(j,2)==1
                a(i,j)=array(k);
            else a(i,j)=array(k+2);
            end
        end
        k=k+4;
    end
    im
    a 
    subplot(2,1,1);
    imshow(im);
    title('Original image');
    subplot(2,1,2);
    imshow(a);
    title('Decoded image');
