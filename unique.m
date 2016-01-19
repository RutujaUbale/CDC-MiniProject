function[uni]=uniq(a)
uni=[];
for i=1:length(a)
    flag=0;
    for j=1:length(uni)
        if a(i)==uni(j)
            flag=1;
        end
    end
        if flag==0
            uni=[uni(:) a(i)];
        end
end
